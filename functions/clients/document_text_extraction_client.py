import json
import re
import tempfile
from typing import Any, Optional

import pymupdf
from core.logger import logger
from firebase_admin import storage
from openrouter import OpenRouter


class OpenRouterError(Exception):
    pass


class PDFExtractionError(Exception):
    pass


class DocumentExtractionsError(Exception):
    pass


class OpenRouterClient:
    def __init__(
        self,
        model_name: str,
        api_key: str,
    ) -> None:
        self.model_name = model_name
        self.open_router_client = OpenRouter(api_key=api_key)

    def get_response(self, query: str, system_prompt: Optional[str] = None) -> str:
        messages = []

        if not isinstance(query, str) or not (
            system_prompt is None or isinstance(system_prompt, str)
        ):
            raise ValueError("Provided query or system prompt is not a str type")

        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})
        messages.append({"role": "user", "content": query})

        try:
            resp = self.open_router_client.chat.send(
                model=self.model_name, messages=messages
            )

        except Exception as e:
            raise OpenRouterError(f"OpenRouter request failed: {e}")

        try:
            content = resp.choices[0].message.content

        except Exception as e:
            raise OpenRouterError("Could not get message content from OpenRouter")

        return content


PL_EXAMPLE = """PROFIT & LOSS STATEMENT
Company: Acme Tech Solutions, Inc.
Period: January 1, 2025 - December 31, 2025

----------------------------------------
REVENUE
----------------------------------------
Product Sales..................$420,000
Subscription Services..........$180,000
Consulting Revenue..............$75,000
----------------------------------------
Total Revenue..................$675,000


----------------------------------------
COST OF GOODS SOLD (COGS)
----------------------------------------
Hosting & Infrastructure........$85,000
Payment Processing Fees........$18,000
Direct Labor...................$72,000
----------------------------------------
Total COGS....................$175,000


----------------------------------------
GROSS PROFIT
----------------------------------------
Gross Profit..................$500,000


----------------------------------------
OPERATING EXPENSES
----------------------------------------
Salaries & Wages..............$210,000
Rent & Utilities...............$36,000
Marketing & Advertising........$42,000
Software & Tools...............$24,000
Insurance.......................$9,000
Office & Miscellaneous.........$14,000
----------------------------------------
Total Operating Expenses......$335,000


----------------------------------------
OPERATING INCOME
----------------------------------------
Operating Income..............$165,000


----------------------------------------
OTHER EXPENSES
----------------------------------------
Interest Expense...............$6,000
Taxes..........................$32,000
----------------------------------------
Total Other Expenses...........$38,000


========================================
NET PROFIT
========================================
Net Profit....................$127,000
========================================
"""
SYSTEM_PROMPT = f"""
You are a financial statement extraction engine.

Task:
Given a profit & loss statement (P&L) in plain text, extract:
- total_revenue: total revenue for the period
- total_expenses: total expenses for the period, defined as (COGS + operating expenses + other expenses). If the statement provides an explicit total expenses value, use it. Otherwise, compute it by summing the relevant expense sections.

Rules:
- Prefer explicit totals labeled like "Total Revenue", "Total Expenses", "Total COGS", "Total Operating Expenses", "Total Other Expenses".
- If totals are missing, sum the line items within each section.
- Ignore non-numeric text, headers, page numbers, and formatting characters (commas, $).
- Output MUST be a single JSON object and nothing else.

Output format (valid JSON):
{{"total_revenue": <number>, "total_expenses": <number>}}

Example:
Input:
{PL_EXAMPLE}

Correct output:
{{"total_revenue": 675000, "total_expenses": 548000}}
""".strip()


def extract_json_from_llm_response(resp: str) -> dict:
    """
    Extracts JSON object from LLM response, stripping Markdown backticks if present.
    Converts numeric strings with commas or $ to numbers.
    """
    # Remove ```json or ``` blocks
    resp = re.sub(r"^```json\s*|\s*```$", "", resp.strip(), flags=re.MULTILINE)

    # Extract the first {...} block
    match = re.search(r"\{.*\}", resp, re.DOTALL)
    if not match:
        raise ValueError("No JSON object found in LLM response")

    json_str = match.group(0)

    # Remove trailing commas
    json_str = re.sub(r",\s*}", "}", json_str)
    json_str = re.sub(r",\s*\]", "]", json_str)

    # Parse JSON
    data = json.loads(json_str)

    # Convert numbers if strings
    for key in ["total_revenue", "total_expenses"]:
        if key in data:
            if isinstance(data[key], str):
                data[key] = float(data[key].replace(",", "").replace("$", ""))
            else:
                data[key] = float(data[key])  # in case it's like 807.1
    return data


class DocumentTextExtractionClient:
    def __init__(self, open_router_client: OpenRouterClient) -> None:
        self.open_router_client = open_router_client

    def _extract_text_from_pdf(self, pdf_path: str) -> list[str]:
        logger.info(f"Starting PDF text extraction from: {pdf_path}")

        # Create a temporary file
        with tempfile.NamedTemporaryFile(suffix=".pdf") as temp_file:
            try:
                bucket = storage.bucket()
                blob = bucket.blob(pdf_path)  # pdf_path is like "business/.../file.pdf"
                blob.download_to_filename(temp_file.name)
                logger.info(f"Downloaded PDF to temporary file: {temp_file.name}")
            except Exception as e:
                logger.error(f"Failed to download PDF from Firebase Storage: {e}")
                raise PDFExtractionError(f"Could not download PDF: {e}")

            # Now open the temp file with pymupdf
            pdf_text: list[str] = []
            try:
                import fitz  # pymupdf

                with fitz.open(temp_file.name) as pdf_file:
                    for i, page in enumerate(pdf_file):
                        page_text = page.get_text()
                        if page_text:
                            pdf_text.append(page_text)
                            logger.debug(
                                f"Extracted text from page {i + 1}: {len(page_text)} characters"
                            )
            except Exception as e:
                logger.error(f"Failed to extract text from PDF {pdf_path}: {e}")
                raise PDFExtractionError(f"Could not extract text from pdf: {e}")

        logger.info(
            f"Completed PDF text extraction from: {pdf_path}, total pages: {len(pdf_text)}"
        )
        return pdf_text

    def get_statement_details(self, pl_statement_path: str) -> dict[str, Any]:
        logger.info(f"Starting P&L statement extraction for: {pl_statement_path}")
        try:
            pdf_text_per_page = self._extract_text_from_pdf(pl_statement_path)
        except (ValueError, PDFExtractionError) as e:
            logger.error(f"Error extracting text from PDF: {e}")
            raise DocumentExtractionsError(
                "Could not extract text from PL statement document."
            )

        pl_statement = "\n".join(pdf_text_per_page)
        logger.debug(f"P&L statement text:\n{pl_statement}")

        try:
            llm_response = self.open_router_client.get_response(
                f"Extract the total annual revenue and expenditures from the following profit-loss statement: {pl_statement}",
                SYSTEM_PROMPT,
            )
            logger.debug(f"LLM raw response: {llm_response}")
        except OpenRouterError as e:
            logger.error(f"LLM extraction error: {e}")
            raise DocumentExtractionsError(
                "An error occurred while extracting the expenditure and revenue of the PL statement"
            )

        try:
            parsed_response = extract_json_from_llm_response(llm_response)
            if "total_revenue" not in parsed_response:
                logger.error("total_revenue missing from LLM response")
                raise ValueError("total_revenue missing from response")
            if "total_expenses" not in parsed_response:
                logger.error("total_expenses missing from LLM response")
                raise ValueError("total_expenses missing from response")
        except Exception as e:
            logger.error(f"Failed to parse LLM response: {e}")
            raise DocumentExtractionsError("Response was not in expected form")

        logger.info(
            f"Successfully extracted P&L details: total_revenue={parsed_response['total_revenue']}, "
            f"total_expenses={parsed_response['total_expenses']}"
        )

        return {
            "total_revenue": parsed_response["total_revenue"],
            "total_expenses": parsed_response["total_expenses"],
        }


router_client: OpenRouterClient = OpenRouterClient(
    model_name="deepseek/deepseek-chat-v3.1",
    api_key="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",
)
doc_client: DocumentTextExtractionClient = DocumentTextExtractionClient(
    open_router_client=router_client
)

from typing import Optional
import json

from openrouter import OpenRouter
import pymupdf


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
SYSTEM_PROMPT = f"""You are an expert financial analysts searching for organization's total annual revenue and total annual expenditures. Your findings must be in the form of JSON.\n Response Format:\n{{'total_expenditures':numeric, 'total_revenue':numeric}}For example in the following example, your response would be {{'total_revenue':675000, 'total_expenses':548000}}: {PL_EXAMPLE}\nInstructions: \n- Calculate the total revenue for the company\n-Calculate the total expenses for the company\nConstraints:\n-Values for total_revenue and total_expenses MUST be numeric (float or int)\n-Your response MUST be valid JSON"""


class DocumentTextExtractionClient:
    def __init__(self, open_router_client: OpenRouterClient) -> None:
        self.open_router_client = open_router_client

    def _extract_text_from_pdf(self, pdf_path: str) -> list[str]:
        if pdf_path.split(".")[-1] != "pdf":
            raise ValueError(f"{pdf_path} is not a pdf")

        pdf_text: list[str] = []
        try:
            with pymupdf.open(pdf_path) as pdf_file:
                for page in pdf_file:
                    pdf_content = page.get_text()
                    if pdf_content:
                        pdf_text.append(pdf_content)
        except Exception as e:
            raise PDFExtractionError(
                f"Could not extract text from pdf located at {pdf_path}: {e}"
            )
        return pdf_text

    def get_statement_details(self, pl_statement_path: str) -> dict:
        pdf_text_per_page: list[str]
        try:
            pdf_text_per_page = self._extract_text_from_pdf(pl_statement_path)
        except (ValueError, PDFExtractionError) as e:
            raise DocumentExtractionsError(
                "Could not extract text from PL statement document."
            )
        pl_statement = "\n".join(pdf_text_per_page)
        print(
            f"================ PL STATEMENT =============================\n{pl_statement}"
        )
        llm_response: str

        try:
            llm_response = self.open_router_client.get_response(
                f"Extract the total annual revenue and expenditures from the following profit-loss statement: {pl_statement}",
                SYSTEM_PROMPT,
            )
            print(f"============ LLM RESPONSE =============\n{llm_response}")
        except OpenRouterError:
            raise DocumentExtractionsError(
                "An error occurred while exracting the expenditure and revenue of the PL statement"
            )

        try:
            parsed_response = json.loads(llm_response)
            if "total_revenue" not in parsed_response:
                raise ValueError("total_revenue missing from response")
            if "total_expenditures" not in parsed_response:
                raise ValueError("total_expenditures missing from response")
        except Exception as e:
            raise DocumentExtractionsError("Response was not in expected form")

        return {
            "total_revenue": parsed_response["total_revenue"],
            "total_expenditures": parsed_response["total_expenditures"],
        }

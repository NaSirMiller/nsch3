from clients.document_text_extraction_client import (
    DocumentTextExtractionClient,
    OpenRouterClient,
)


def main():
    router_client: OpenRouterClient = OpenRouterClient(
        model_name="deepseek/deepseek-chat-v3.1", api_key=""
    )
    doc_client: DocumentTextExtractionClient = DocumentTextExtractionClient(
        open_router_client=router_client
    )
    pl_res = doc_client.get_statement_details(
        pl_statement_path="../data/CFI-PL-Statement-2018.pdf"
    )
    print(pl_res)


if __name__ == "__main__":
    main()

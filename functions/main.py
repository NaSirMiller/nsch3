from typing import Any, Optional

from clients.document_text_extraction_client import (
    DocumentExtractionsError,
    DocumentTextExtractionClient,
    doc_client,
    router_client,
)
from core.logger import logger
from firebase_admin import initialize_app
from firebase_admin.firestore import firestore
from firebase_functions import https_fn
from firebase_functions.firestore_fn import (
    Event,
    on_document_created,
)
from firebase_functions.options import set_global_options
from services.exchange_shares_service import (
    ExchangeSharesServiceError,
    exchange_shares_service,
)

initialize_app()

# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10)


@https_fn.on_call()
def exchange_business_to_investor(
    req: https_fn.CallableRequest[dict[str, Any]],
) -> dict[str, Any]:
    data = req.data

    business_id = data.get("business_id")
    investor_id = data.get("investor_id")
    num_shares = data.get("num_shares")

    if business_id is None or investor_id is None or num_shares is None:
        logger.error(
            "Missing arg",
            business_id=business_id,
            investor_id=investor_id,
            num_shares=num_shares,
        )
        return {"status": 400, "error": "Missing arg"}

    try:
        exchange_shares_service.exchange_shares_business_to_investor(
            business_id, investor_id, num_shares
        )
    except ExchangeSharesServiceError as e:
        logger.error(
            f"ExchangeSharesServiceError occurred while exchanging shares: {e}",
            business_id=business_id,
            investor_id=investor_id,
        )
        return {"status": 500, "error": "An internal error occurred"}

    return {"status": 200}


@https_fn.on_call()
def get_revenue_and_expenses_from_pl_statement(
    req: https_fn.CallableRequest[dict[str, Any]],
) -> dict[str, Any]:
    logger.debug(f"Doing expense stuff: {req}")
    data = req.data
    pl_statement_path = data.get("pl_statement_path")

    if not pl_statement_path:
        logger.error("pl_statement_path is not valid (empty or None)")
        return {
            "status": 400,
            "error": "pl_statement_path is not valid (empty or None)",
        }

    try:
        rev_and_expenses = doc_client.get_statement_details(pl_statement_path)
    except DocumentExtractionsError as e:
        logger.error(f"DocumentExtractionError occurred: {e}")
        return {"status": 500, "error": "An internal error occurred"}

    return rev_and_expenses

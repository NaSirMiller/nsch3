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

# Initialize Firebase Admin SDK
initialize_app()

set_global_options(max_instances=10)


@https_fn.on_call()
def exchange_business_to_investor(
    req: https_fn.CallableRequest[dict[str, Any]],
) -> dict[str, Any]:
    """Exchange shares from business to investor (callable function)"""

    logger.info("=" * 50)
    logger.info("EXCHANGE CALLABLE FUNCTION CALLED")
    logger.info(f"Auth context: {req.auth}")
    logger.info(f"Request data: {req.data}")
    logger.info("=" * 50)

    data = req.data
    business_id = data.get("business_id")
    investor_id = data.get("investor_id")
    num_shares = data.get("num_shares")

    logger.info(f"Extracted parameters:")
    logger.info(f"  business_id: {business_id}")
    logger.info(f"  investor_id: {investor_id}")
    logger.info(f"  num_shares: {num_shares}")

    if business_id is None or investor_id is None or num_shares is None:
        logger.error(
            "Missing required arguments",
            business_id=business_id,
            investor_id=investor_id,
            num_shares=num_shares,
        )
        return {"status": 400, "error": "Missing required arguments"}

    try:
        logger.info("Calling exchange_shares_service...")
        exchange_shares_service.exchange_shares_business_to_investor(
            business_id, investor_id, num_shares
        )
        logger.info("Exchange completed successfully")
        return {"status": 200, "message": f"Successfully exchanged {num_shares} shares"}

    except ExchangeSharesServiceError as e:
        logger.error(
            f"ExchangeSharesServiceError occurred while exchanging shares: {e}",
            business_id=business_id,
            investor_id=investor_id,
        )
        return {"status": 500, "error": f"Exchange failed: {str(e)}"}
    except Exception as e:
        logger.error(f"Unexpected error during exchange: {e}")
        return {"status": 500, "error": "An internal error occurred"}


@https_fn.on_request()
def get_revenue_and_expenses_from_pl_statement(
    req: https_fn.Request,
) -> https_fn.Response:
    """Get revenue and expenses from P&L statement"""
    import json

    headers = {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
    }

    if req.method == "OPTIONS":
        return https_fn.Response("", status=204, headers=headers)

    try:
        data = req.get_json(force=True, silent=True)

        if data is None:
            logger.error("pl_statement_path is not valid (empty or None)")
            return https_fn.Response(
                response=json.dumps({"status": 400, "error": "Invalid request"}),
                status=400,
                headers=headers,
            )

        pl_statement_path = data.get("pl_statement_path")

        if not pl_statement_path:
            logger.error("pl_statement_path is not valid (empty or None)")
            return https_fn.Response(
                response=json.dumps(
                    {"status": 400, "error": "pl_statement_path is required"}
                ),
                status=400,
                headers=headers,
            )

        rev_and_expenses = doc_client.get_statement_details(pl_statement_path)

        return https_fn.Response(
            response=json.dumps(rev_and_expenses), status=200, headers=headers
        )

    except DocumentExtractionsError as e:
        logger.error(f"DocumentExtractionsError: {e}")
        return https_fn.Response(
            response=json.dumps({"status": 500, "error": "An internal error occurred"}),
            status=500,
            headers=headers,
        )
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return https_fn.Response(
            response=json.dumps({"status": 500, "error": "An internal error occurred"}),
            status=500,
            headers=headers,
        )

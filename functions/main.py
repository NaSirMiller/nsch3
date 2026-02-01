# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from typing import Optional

from firebase_admin import initialize_app
from firebase_admin.firestore import firestore
from firebase_functions import https_fn
from firebase_functions.firestore_fn import (
    Event,
    on_document_created,
)
from firebase_functions.options import set_global_options

from core.logger import logger
from services.exchange_shares_service import (
    ExchangeSharesServiceError,
    exchange_shares_service,
)

# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10)


@https_fn.on_request()
def exchange_business_to_investor(req: https_fn.Request) -> https_fn.Response:
    data = req.get_json()

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
        return https_fn.Response({"status": 400, "error": "Missing arg"})

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
        return https_fn.Response({"status": 500, "error": "An internal error occurred"})

    return https_fn.Response({"status": 200})

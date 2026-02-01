from firebase_admin.exceptions import FirebaseError
from firebase_admin.firestore import firestore
from pydantic import ValidationError

from core import singletons
from core.logger import logger
from models.business import Business


class BusinessRepositoryError(Exception):
    pass


class BusinessRepository:
    _firestore_client: firestore.Client = singletons.firestore_client
    businesses_collection_name = "businesses"

    def get_business_by_id(
        self, business_id: str, transaction: firestore.Transaction | None = None
    ) -> Business:
        try:
            result = (
                self._firestore_client.collection(self.businesses_collection_name)
                .document(business_id)
                .get(transaction=transaction)
            )
        except FirebaseError as e:
            logger.error(
                "FirebaseError occurred while getting business",
                error=e,
                business_id=business_id,
            )
            raise BusinessRepositoryError(
                "A FirebaseError occurred while getting business"
            ) from e

        assert isinstance(result, firestore.DocumentSnapshot)

        try:
            return Business.model_validate(result.to_dict())
        except ValidationError as e:
            logger.error(
                "Validation error occurred while converting doc to Business",
                error=e,
                business_id=business_id,
            )
            raise BusinessRepositoryError(
                "A ValidationError occurred while converting doc to Business"
            ) from e

    def decrement_shares_available(
        self, business_id: str, num_shares: int, transaction: firestore.Transaction
    ) -> None:
        logger.debug(
            "Decrementing shares available",
            business_id=business_id,
            num_shares=num_shares,
        )
        assert num_shares > 0
        ref = self._firestore_client.collection(
            self.businesses_collection_name
        ).document(business_id)
        try:
            transaction.update(
                ref, {"sharesAvailable": firestore.Increment(-1 * num_shares)}
            )
        except FirebaseError as e:
            logger.error(
                f"FirebaseError occurred while decrementing shares available: {e}",
                business_id=business_id,
                num_shares=num_shares,
            )
            raise BusinessRepositoryError("A FirebaseError occurred") from e


business_repository = BusinessRepository()

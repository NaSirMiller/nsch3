from core import singletons
from core.logger import logger
from firebase_admin.exceptions import FirebaseError
from firebase_admin.firestore import firestore
from models.business import Business
from pydantic import ValidationError


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

    def increment_business_investors(
        self,
        business_id: str,
        num_investors: int = 1,
        transaction: firestore.Transaction | None = None,
    ) -> None:
        """
        Increment the number of investors for a business atomically.
        Defaults to incrementing by 1.
        """
        if num_investors <= 0:
            raise ValueError("num_investors must be positive")

        ref = self._firestore_client.collection(
            self.businesses_collection_name
        ).document(business_id)

        try:
            if transaction:
                transaction.update(
                    ref, {"numInvestors": firestore.Increment(num_investors)}
                )
            else:
                ref.update({"numInvestors": firestore.Increment(num_investors)})
        except FirebaseError as e:
            logger.error(
                "FirebaseError occurred while incrementing numInvestors",
                error=e,
                business_id=business_id,
                num_investors=num_investors,
            )
            raise BusinessRepositoryError("A FirebaseError occurred") from e


business_repository = BusinessRepository()

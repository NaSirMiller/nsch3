from datetime import datetime, timezone

from firebase_admin.exceptions import FirebaseError
from firebase_admin.firestore import firestore

from core import singletons
from core.logger import logger
from models.transaction.create_transaction import CreateTransaction


class TransactionRepository:
    _firestore_client = singletons.firestore_client

    _transactions_collection_name = "transactions"

    def store_transaction(
        self,
        transaction: CreateTransaction,
        firestore_transaction: firestore.Transaction,
    ) -> None:
        try:
            ref = self._firestore_client.collection(
                self._transactions_collection_name
            ).document()
            firestore_transaction.set(
                ref,
                {**transaction.model_dump(), "timestamp": datetime.now(timezone.utc)},
            )
        except FirebaseError as e:
            logger.error(
                f"FirebaseError occurred while storing transaction: {e}",
            )


transaction_repository = TransactionRepository()

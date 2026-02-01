from datetime import datetime, timezone

from firebase_admin.firestore import firestore

from models.transaction.create_transaction import CreateTransaction
from repositories.business_repository import (
    BusinessRepositoryError,
    business_repository,
)
from repositories.portfolio_repository import portfolio_repository
from repositories.transaction_repository import transaction_repository


class ExchangeSharesServiceError(Exception):
    pass


_firestore_client = firestore.Client()


class ExchangeSharesService:
    def exchange_shares_business_to_investor(
        self,
        business_id: str,
        investor_id: str,
        num_shares: int,
    ) -> None:
        if num_shares <= 0:
            raise ExchangeSharesServiceError("num_shares must be positive")

        @firestore.transactional
        def run_transaction(transaction: firestore.Transaction):
            try:
                business = business_repository.get_business_by_id(
                    business_id, transaction
                )
            except BusinessRepositoryError as e:
                raise ExchangeSharesServiceError("Couldn't get business") from e

            if business.sharesAvailable < num_shares:
                raise ExchangeSharesServiceError(
                    "Business doesn't have enough available shares"
                )

            transaction_repository.store_transaction(
                CreateTransaction(
                    fromUser=business_id,
                    toUser=investor_id,
                    numShares=num_shares,
                    pricePerShare=business.sharePrice,
                ),
                firestore_transaction=transaction,
            )

            business_repository.decrement_shares_available(
                business_id=business_id,
                num_shares=num_shares,
                transaction=transaction,
            )

            portfolio_repository.increment_holding_share_count(
                investor_id=investor_id,
                ticker=business.ticker,
                num_shares=num_shares,
                share_price=business.sharePrice,
                transaction=transaction,
            )

        run_transaction(_firestore_client.transaction())


exchange_shares_service = ExchangeSharesService()

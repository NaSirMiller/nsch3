from core import singletons
from core.logger import logger
from firebase_admin.exceptions import FirebaseError
from firebase_admin.firestore import firestore
from models.holding import Holding


class PortfolioRepositoryError(Exception):
    pass


class PortfolioRepository:
    _firestore_client: firestore.Client = singletons.firestore_client
    portfolios_collection_name = "portfolios"
    holdings_collection_name = "holdings"

    def increment_holding_share_count(
        self,
        investor_id: str,
        ticker: str,
        num_shares: int,
        share_price: float,
    ) -> None:
        holding_ref = (
            self._firestore_client.collection(self.portfolios_collection_name)
            .document(investor_id)
            .collection(self.holdings_collection_name)
            .document(ticker)
        )

        try:
            snapshot = holding_ref.get()  # no transaction

            if snapshot.exists:
                # Atomic increment outside transaction
                holding_ref.update({"numShares": firestore.Increment(num_shares)})
            else:
                # Create the holding if it doesn't exist
                holding_ref.set(
                    Holding(
                        ticker=ticker,
                        sharePrice=share_price,
                        numShares=num_shares,
                    ).model_dump()
                )

        except FirebaseError as e:
            logger.error(
                "FirebaseError occurred while incrementing holding share count",
                error=e,
                investor_id=investor_id,
                ticker=ticker,
            )
            raise PortfolioRepositoryError("A FirebaseError occurred") from e


portfolio_repository = PortfolioRepository()

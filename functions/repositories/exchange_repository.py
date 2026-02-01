from firebase_admin.exceptions import FirebaseError
from firebase_admin.firestore import firestore
from google.api_core.exceptions import GoogleAPIError

from core import singletons
from core.logger import logger
from models.business import Business
from models.portfolio import Portfolio


class ExchangeRepositoryError(Exception):
    pass


class ExchangeRepository:
    def __init__(self) -> None:
        self._firestore_client: firestore.Client = singletons.firestore_client

    def get_investor_portfolio(self, investor_id: str) -> Portfolio:
        try:
            portfolio = (
                self._firestore_client.collection("portfolios")
                .document(investor_id)
                .get()
            )
        except GoogleAPIError as e:
            raise ExchangeRepositoryError(
                f"An error occurred retrieving the portfolio for investor {investor_id}: {e}"
            )

        assert isinstance(portfolio, firestore.DocumentSnapshot)

        if not portfolio.exists:
            raise ExchangeRepositoryError(
                f"Investor {investor_id} does not have a portfolio"
            )

        raw_portfolio_data = portfolio.to_dict()

        assert raw_portfolio_data is not None

        try:
            portfolio = Portfolio.model_validate(raw_portfolio_data)
        except Exception as e:
            raise ExchangeRepositoryError(f"Could not convert to portfolio object: {e}")

        return portfolio

    # def get_user(self, user_id: str) -> User:
    #     pass

    def can_investor_sell(
        self,
        requested_ticker: str,
        requested_num_shares: int,
        portfolio: Portfolio,
    ) -> bool:
        holdings = portfolio.holdings
        try:
            matching_holdings: list[firestore.DocumentSnapshot] = list(
                holdings.where("ticker", "==", requested_ticker)
                .where("share_count", ">=", requested_num_shares)
                .where("isApproved", "==", True)
                .get()
            )
        except FirebaseError as e:
            raise ExchangeRepositoryError("Issue retrieving holding data for portfolio")

        if len(matching_holdings) == 0:
            return False

        if len(matching_holdings) > 1:
            logger.error(
                "Number of matching holdings is not 1",
                num_matching_holdings=len(matching_holdings),
                requested_ticker=requested_ticker,
            )
            raise ExchangeRepositoryError("Number of matching holdings is not 1")

        return True

    def assert_business_can_sell(
        self,
        requested_ticker: str,
        requested_num_shares: int,
        business: Business,
    ) -> bool:
        is_approved = business.isApproved

        return (
            is_approved
            and business.totalSharedIssues < requested_num_shares
            and business.ticker == requested_ticker
        )


exchange_repository = ExchangeRepository()

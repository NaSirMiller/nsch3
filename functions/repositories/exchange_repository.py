from models.portfolio import InvestorPortfolio
from models.user import User
from models.business import Business
from google.cloud import firestore
from google.api_core.exceptions import GoogleAPIError


class ExchangeRepositoryError(Exception):
    pass


class ExchangeRepository:
    def __init__(self) -> None:
        self._firestore_client: firestore.Client = firestore.client()

    def get_investor_portfolio(self, investor_id: str) -> InvestorPortfolio:
        try:
            raw_portfolio = (
                self._firestore_client.collection("portfolios")
                .document(investor_id)
                .get()
            )
        except GoogleAPIError as e:
            raise ExchangeRepositoryError(
                f"An error occurred retrieving the portfolio for investor {investor_id}"
            )

        if not raw_portfolio.exists():
            raise ExchangeRepository(
                f"Investor {investor_id} does not have a portfolio"
            )

        raw_portfolio_data = raw_portfolio.to_dict()

        try:
            portfolio = InvestorPortfolio.model_validate_json(raw_portfolio_data)
        except Exception as e:
            raise ExchangeRepositoryError(f"Could not convert to portfolio object: {e}")

        return portfolio

    def get_user(self, user_id: str) -> User:
        pass

    def assert_investor_can_sell(
        self,
        requested_ticker: str,
        requested_num_shares: int,
        portfolio: InvestorPortfolio,
    ) -> bool:
        try:
            holdings: firestore.CollectionReference = portfolio.holdings
        except Exception as e:
            raise ExchangeRepositoryError(
                "Could not find holdings for the provided portfolio"
            )
        try:
            matching_holdings: list[firestore.DocumentSnapshot] = (
                holdings.where("ticker", "==", requested_ticker)
                .where("share_count", ">=", requested_num_shares)
                .where("isApproved", "==", True)
                .get()
            )
        except Exception as e:
            raise ExchangeRepositoryError("Issue retrieving holding data for portfolio")

        if not matching_holdings or any(matching_holdings.exists()):
            raise ExchangeRepositoryError(
                f"User does not have any valid holdings for {requested_ticker}"
            )

    def assert_business_can_sell(
        self,
        requested_ticker: str,
        requested_num_shares: int,
        business: Business,
    ) -> bool:
        business_data = business.model_dump()
        is_approved: bool = business.get("isApproved", False)

        if (
            not is_approved
            or (business_data.get("totalSharesIssued", 0) < requested_num_shares)
            or (business_data.get("ticker", "") == requested_ticker)
        ):
            raise ExchangeRepositoryError(
                f"Business does not have the ability to sell {requested_ticker} shares."
            )


exchange_repository = ExchangeRepository()

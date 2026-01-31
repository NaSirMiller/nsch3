from repositories.exchange_repository import (
    ExchangeRepository,
    ExchangeRepositoryError,
    exchange_repository as _exchange_repository,
)
from models.portfolio import InvestorPortfolio


class ExchangeServiceError(Exception):
    pass


class ExchangeService:
    def __init__(
        self,
        exchange_repository: ExchangeRepository = _exchange_repository,
    ) -> None:
        self.exchange_repository = exchange_repository

    def exchange_shares(
        self,
        vendor_id: str,
        investor_id: str,
        ticker: str,
        num_shares: int,
    ) -> None:

        try:
            investor_portfolio: InvestorPortfolio = (
                self.exchange_repository.get_investor_portfolio(investor_id)
            )
        except ExchangeRepositoryError as e:
            raise ExchangeServiceError(
                f"Could not retrieve a portfolio for {investor_id}"
            )
        try:
            self.exchange_repository.assert_investor_can_sell(
                ticker, num_shares, investor_portfolio
            )
        except ExchangeRepositoryError as e:
            raise ExchangeServiceError("")

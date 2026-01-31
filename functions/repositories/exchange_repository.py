from models.portfolio import InvestorPortfolio


class ExchangeRepositoryError(Exception):
    pass


class ExchangeRepository:
    def __init__() -> None:
        pass

    def get_investor_portfolio(self, investor_id: str) -> InvestorPortfolio:
        pass


exchange_repository = ExchangeRepository()

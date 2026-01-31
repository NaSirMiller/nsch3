from repositories.exchange_repository import (
    ExchangeRepository,
    exchange_repository as _exchange_repository,
)


class ExchangeServiceError(Exception):
    pass


class ExchangeService:
    def __init__(
        self,
        exchange_repository: ExchangeRepository = _exchange_repository,
    ) -> None:
        self.exchange_repository = exchange_repository

    def exchange_shares(self, vendor_id: str, investor_id: str) -> None:
        pass

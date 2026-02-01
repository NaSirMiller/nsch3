from pydantic import BaseModel


class Holding(BaseModel):
    ticker: str
    sharePrice: float
    numShares: int

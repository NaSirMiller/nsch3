from pydantic import BaseModel


class CreateTransaction(BaseModel):
    fromUser: str
    toUser: str
    numShares: int
    pricePerShare: float

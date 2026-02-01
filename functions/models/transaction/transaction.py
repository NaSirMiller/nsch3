from datetime import datetime

from pydantic import BaseModel


class Transaction(BaseModel):
    id: str
    fromUser: str
    toUser: str
    numShares: int
    timestamp: datetime
    pricePerShare: float

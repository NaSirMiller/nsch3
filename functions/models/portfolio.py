from pydantic import BaseModel
from typing import Optional

from google.cloud import firestore


class IncomingInvestorPortfolio(BaseModel):
    user_id: str
    holdings: Optional[firestore.CollectionReference]


class InvestorPortfolio(BaseModel):
    user_id: str
    holdings: firestore.CollectionReference

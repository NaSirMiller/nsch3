from pydantic import BaseModel
from google.cloud import firestore


class IncomingInvestorPortfolio(BaseModel):
    user_id: str
    holdings: firestore.CollectionReference


class InvestorPortfolio(BaseModel):
    user_id: str
    holdings: firestore.CollectionReference

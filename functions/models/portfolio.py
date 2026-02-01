from google.cloud import firestore
from pydantic import BaseModel


class Portfolio(BaseModel):
    user_id: str
    holdings: firestore.CollectionReference

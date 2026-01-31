from typing import Optional
from pydantic import BaseModel


class IncomingUser(BaseModel):
    user_id: str
    first_name: Optional[str]
    last_name: Optional[str]
    email: Optional[str]
    role: Optional[str]
    profile_logo_filepath: Optional[str]


class User(BaseModel):
    user_id: str
    first_name: str
    last_name: str
    email: str
    role: str
    profile_logo_filepath: Optional[str]

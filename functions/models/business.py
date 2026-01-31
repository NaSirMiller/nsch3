from typing import Optional
from pydantic import BaseModel


class IncomingBusiness(BaseModel):
    business_id: str
    description: Optional[str]
    industry: Optional[str]
    logo_filepath: Optional[str]
    pl_doc_filepath: Optional[str]
    projectedRevenue: Optional[float]
    projectedExpenses: Optional[float]
    # projectedProfit: Optional[float] -> projectedRevenue - projectedExpenses
    valuation: Optional[float]
    totalSharedIssues: Optional[float]
    sharePrice: Optional[float]
    divdendPercentage: Optional[float]
    isApproved: Optional[bool]
    ticker: Optional[str]


class Business(BaseModel):
    business_id: str
    description: str
    industry: str
    logo_filepath: str
    pl_doc_filepath: str
    projectedRevenue: float
    projectedExpenses: float
    # projectedProfit -> projectedRevenue - projectedExpenses
    valuation: float
    totalSharedIssues: float
    sharePrice: float
    divdendPercentage: Optional[float]
    isApproved: bool
    ticker: str

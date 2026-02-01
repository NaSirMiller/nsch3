from typing import Optional

from pydantic import BaseModel


class Business(BaseModel):
    id: str
    description: str
    industry: str
    logoFilepath: str
    plDocFilepath: str
    projectedRevenue: float
    projectedExpenses: float
    # projectedProfit -> projectedRevenue - projectedExpenses
    valuation: float
    totalSharesIssues: int
    sharesAvailable: int
    sharePrice: float
    divdendPercentage: Optional[float]
    isApproved: bool
    ticker: str

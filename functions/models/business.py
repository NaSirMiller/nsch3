from typing import Optional

from pydantic import BaseModel, Field


class Business(BaseModel):
    uid: str  # Changed from 'id'
    name: str  # Added - was missing
    description: str
    industry: str
    logoFilepath: str
    plDocFilepath: str
    projectedRevenue: float
    projectedExpenses: float
    projectedProfit: float  # Added - was missing
    valuation: float
    totalSharesIssued: int  # Fixed typo from 'totalSharesIssues'
    sharePrice: float
    dividendPercentage: float  # Fixed typo from 'divdendPercentage'
    isApproved: bool
    address: str
    goal: float  # Changed to float to match Dart
    numInvestors: int
    amountRaised: int
    yearFounded: str  # Fixed from 'year_founded'

    # These might be in Firestore but not in Dart model - keep optional
    sharesAvailable: int
    ticker: str

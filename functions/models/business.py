from typing import Optional

from pydantic import BaseModel, Field


class Business(BaseModel):
    uid: Optional[str] = None  # Changed from 'id'
    name: Optional[str] = None  # Added - was missing
    description: Optional[str] = None
    industry: Optional[str] = None
    logoFilepath: Optional[str] = None
    plDocFilepath: Optional[str] = None
    projectedRevenue: Optional[float] = None
    projectedExpenses: Optional[float] = None
    projectedProfit: Optional[float] = None  # Added - was missing
    valuation: Optional[float] = None
    totalSharesIssued: Optional[int] = None  # Fixed typo from 'totalSharesIssues'
    sharePrice: Optional[float] = None
    dividendPercentage: Optional[float] = None  # Fixed typo from 'divdendPercentage'
    isApproved: Optional[bool] = None
    address: Optional[str] = None
    goal: Optional[float] = None  # Changed to float to match Dart
    numInvestors: Optional[int] = None
    amountRaised: Optional[int] = None
    yearFounded: Optional[str] = None  # Fixed from 'year_founded'

    # These might be in Firestore but not in Dart model - keep optional
    sharesAvailable: Optional[int] = None
    ticker: Optional[str] = None

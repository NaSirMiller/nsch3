from models.business import Business
from models.evaluation_results import BusinessEvaluationResults
from repositories.business_repository import (
    BusinessRepositoryError,
    business_repository,
)

from functions.core.logger import logger


class BusinessEvaluationServiceError(Exception):
    pass


PROFIT_TO_BUSINESS_CLASSES: dict[str, tuple[int, int | float]] = {
    "micro": (0, 249_999),
    "small": (250_000, 499_999),
    "large": (500_000, 999_999),
    "in_demand": (1_000_000, float("inf")),
}
BUSINESS_CLASSES_TO_SHARES_ALLOWED: dict[str, int] = {
    "micro": 1_000,
    "small": 2_500,
    "large": 5_000,
    "in_demand": 10_000,
}
BUSINESS_CLASSES_TO_PL_BONUS: dict[str, float] = {
    "micro": 2,
    "small": 2.5,
    "large": 3,
    "in_demand": 4,
}


class BusinessEvaluationService:
    def _assign_business_class(self, business_id: str, net_profit: float) -> str:
        logger.debug(
            f"Assigning business class for id={business_id} with net_profit={net_profit}"
        )
        business_class: str | None = None
        for b_class, (lower, upper) in PROFIT_TO_BUSINESS_CLASSES.items():
            if lower <= net_profit <= upper:
                business_class = b_class
                break
        if business_class is None:
            logger.error(f"Failed to assign business class for id={business_id}")
            raise RuntimeError(
                f"Could not assign a business class to business with id={business_id}"
            )
        logger.info(f"Business id={business_id} classified as '{business_class}'")
        return business_class

    def get_evaluation(self, business_id: str) -> BusinessEvaluationResults:
        logger.info(f"Starting evaluation for business id={business_id}")
        try:
            business = business_repository.get_business_by_id(business_id)
            logger.debug(f"Retrieved business data: {business}")
        except BusinessRepositoryError as e:
            logger.error(f"Error retrieving business id={business_id}: {e}")
            raise BusinessEvaluationServiceError(
                f"Could not retrieve data for business with id={business_id}"
            )

        net_profit: float = business.projectedRevenue - business.projectedExpenses
        logger.debug(f"Calculated net profit for id={business_id}: {net_profit}")

        try:
            business_class = self._assign_business_class(business_id, net_profit)
        except RuntimeError as e:
            logger.error(f"Business classification failed for id={business_id}: {e}")
            raise BusinessEvaluationServiceError("Could not assign a business class")

        shares_allowed: int = BUSINESS_CLASSES_TO_SHARES_ALLOWED[business_class]
        business_bonus: float = BUSINESS_CLASSES_TO_PL_BONUS[business_class]
        price_per_share: float = (net_profit * business_bonus) / shares_allowed

        logger.info(
            f"Evaluation complete for id={business_id}: "
            f"class={business_class}, shares_allowed={shares_allowed}, price_per_share={price_per_share}"
        )

        return BusinessEvaluationResults(
            pricePerShare=price_per_share,
            sharesAllowed=shares_allowed,
            businessClass=business_class,
        )

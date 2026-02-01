import logging
import logging.config
import os
from typing import Any


def get_logging_config(
    env: str = "dev",
    log_format: str = "%(asctime)s [%(levelname)s] %(name)s (%(filename)s:%(lineno)d) - %(message)s",
    log_path: str = "logs/app.log",
) -> dict[str, Any]:
    """
    Returns a logging configuration dictionary based on the environment.

    Args:
        env (str, optional) The environment for which to get the logging configuration.
            Defaults to "dev". Can be "development" or "production".
        log_path (str, optional): The path to the log file. Defaults to "logs/app.log".

    Returns:
        dict[str, Any]: A dictionary containing the logging configuration.
    """
    return {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "dev": {
                "format": log_format,
                "datefmt": "%Y-%m-%d %H:%M:%S",
            },
            "prod": {
                "format": (
                    '{"timestamp": "%(asctime)s", '
                    '"level": "%(levelname)s", '
                    '"logger": "%(name)s", '
                    '"function": "%(funcName)s", '
                    '"message": "%(message)s"}'
                ),
                "datefmt": "%Y-%m-%dT%H:%M:%S",
            },
        },
        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "formatter": "dev" if env == "dev" else "prod",
                "level": "DEBUG" if env == "dev" else "INFO",
            },
            "file": {
                "class": "logging.FileHandler",
                "filename": log_path,
                "formatter": "prod",
                "level": "DEBUG",
            },
        },
        "root": {
            "handlers": ["console", "file"],
            "level": "DEBUG" if env == "dev" else "INFO",
        },
    }


def set_logger(
    env: str = "dev",
    log_format: str = "%(asctime)s [%(levelname)s] %(name)s (%(filename)s:%(lineno)d) - %(message)s",
    log_path: str = "logs/app.log",
) -> None:
    config = get_logging_config(env=env, log_format=log_format, log_path=log_path)
    logging.config.dictConfig(config=config)
    # Silence watchdog debug logs
    logging.getLogger("watchdog").setLevel(logging.WARNING)


class Logger:
    def __init__(
        self,
        logger_name: str = __name__,
        env: str = "dev",
        log_path: str = "logs/app.log",
        log_format: str = (
            "%(asctime)s [%(levelname)s] %(name)s "
            "(%(filename)s:%(lineno)d:%(funcName)s) - %(message)s"
        ),
    ) -> None:
        # Create log file if not made
        os.makedirs(os.path.dirname(log_path), exist_ok=True)
        set_logger(env=env, log_format=log_format, log_path=log_path)
        self._logger = logging.getLogger(logger_name)

    def debug(self, message: str, **kwargs: Any) -> None:
        """Log a debug message."""
        self._logger.debug({"message": message, **kwargs}, stacklevel=2)

    def info(self, message: str, **kwargs: Any) -> None:
        """Log an info message."""
        self._logger.info({"message": message, **kwargs}, stacklevel=2)

    def warning(self, message: str, **kwargs: Any) -> None:
        """Log a warning message."""
        self._logger.warning({"message": message, **kwargs}, stacklevel=2)

    def error(self, message: str, **kwargs: Any) -> None:
        """Log an error message."""
        self._logger.error({"message": message, **kwargs}, stacklevel=2)

    def critical(self, message: str, **kwargs: Any) -> None:
        """Log a critical message."""
        self._logger.critical({"message": message, **kwargs}, stacklevel=2)


__all__ = ["Logger"]

# Instantiate the logger
logger = Logger(logger_name="app_logger")

# Example usage:
# logger.info("App started successfully.")

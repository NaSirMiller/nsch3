from typing import Optional

from openrouter import OpenRouter


class OpenRouterError(Exception):
    pass


class OpenRouterClient:
    def __init__(
        self,
        model_name: str,
        open_router_client: OpenRouter,
    ) -> None:
        self.model_name = model_name
        self.open_router_client = open_router_client

    def get_response(self, query: str, system_prompt: Optional[str] = None) -> str:
        messages = []
        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})
        messages.append({"role": "user", "content": query})

        try:
            resp = self.open_router_client.chat.send(
                model=self.model_name, messages=messages
            )

        except Exception as e:
            raise OpenRouterError(f"OpenRouter request failed: {e}")

        return resp["choices"][0]["message"]["content"]

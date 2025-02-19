class GeminiConfig:
    API_KEY = None  # API Key will be set during runtime
    MODEL_NAME = "gemini-2.0-flash-thinking-exp-01-21"

    @staticmethod
    def set_api_key(api_key):
        GeminiConfig.API_KEY = api_key

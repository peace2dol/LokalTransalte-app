from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    database_url: str = "postgresql+psycopg://lokal:lokal_dev_password@localhost:5432/lokaltranslator"
    llm_base_url: str = ""
    llm_api_key: str = ""
    llm_model: str = ""
    cors_origins: str = "http://localhost:3000,http://localhost:8080"
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

settings = Settings()

from typing import Literal
from pydantic import BaseModel, Field

class TranslateRequest(BaseModel):
    text: str = Field(min_length=1, max_length=5000)
    target_language: Literal["English", "Mandarin"] = "English"
    tone: Literal["casual", "formal"] = "casual"

class SlangItem(BaseModel):
    term: str
    meaning: str
    usage_note: str

class TranslateResponse(BaseModel):
    original_text: str
    normalized_text: str
    translated_text: str
    target_language: str
    tone: str
    slang_breakdown: list[SlangItem]
    provider: str

class AbbreviationCreate(BaseModel):
    short_form: str = Field(min_length=1, max_length=50)
    full_form: str = Field(min_length=1, max_length=100)

class AbbreviationOut(AbbreviationCreate):
    abbr_id: int
    class Config:
        from_attributes = True

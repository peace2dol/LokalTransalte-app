import json
import httpx
from sqlalchemy import select
from sqlalchemy.orm import Session
from .config import settings
from .models import SlangTerm

async def translate(text: str, target: str, tone: str, db: Session):
    # Retrieve only terms that actually occur in the normalized message.
    terms = db.scalars(select(SlangTerm)).all()
    found = [t for t in terms if t.term.casefold() in text.casefold()]
    slang = [{"term": t.term, "meaning": t.meaning, "usage_note": t.usage_note} for t in found]
    if settings.llm_base_url and settings.llm_api_key and settings.llm_model:
        prompt = (
            "You are LokalTranslator, an expert in Malaysian Malay chat language. "
            "Translate the text to the requested language. Preserve intent and names. "
            f"Tone: {tone}. Target: {target}. Contextual slang reference: {json.dumps(slang, ensure_ascii=False)}. "
            "Return JSON only with one string field translated_text."
        )
        async with httpx.AsyncClient(timeout=18) as client:
            response = await client.post(
                settings.llm_base_url.rstrip("/") + "/chat/completions",
                headers={"Authorization": f"Bearer {settings.llm_api_key}"},
                json={"model": settings.llm_model, "messages": [
                    {"role": "system", "content": prompt},
                    {"role": "user", "content": text}
                ], "temperature": 0.2, "response_format": {"type": "json_object"}}
            )
            response.raise_for_status()
            content = response.json()["choices"][0]["message"]["content"]
            translated = json.loads(content)["translated_text"]
            return translated, slang, "llm"
    # Safe demo fallback: makes the API runnable, but is not a real translation engine.
    translated = f"[DEMO – configure an LLM provider for translation] {text}"
    return translated, slang, "demo-fallback"

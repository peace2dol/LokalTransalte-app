from fastapi import Depends, FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session
from .config import settings
from .database import Base, engine, get_db
from .models import ChatAbbreviation
from .normalizer import normalize_chat
from .schemas import AbbreviationCreate, AbbreviationOut, TranslateRequest, TranslateResponse
from .translator import translate

Base.metadata.create_all(bind=engine)
app = FastAPI(title="LokalTranslator API", version="0.1.0", description="Malay chat normalization and translation API")
app.add_middleware(CORSMiddleware, allow_origins=[x.strip() for x in settings.cors_origins.split(",") if x.strip()], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

@app.get("/health")
def health():
    return {"status": "ok", "service": "lokaltranslator-api"}

@app.post("/api/v1/translate", response_model=TranslateResponse)
async def translate_text(payload: TranslateRequest, db: Session = Depends(get_db)):
    if not payload.text.strip():
        raise HTTPException(status_code=422, detail="Text cannot be blank")
    normalized = normalize_chat(payload.text.strip(), db)
    translated, slang, provider = await translate(normalized, payload.target_language, payload.tone, db)
    return TranslateResponse(original_text=payload.text, normalized_text=normalized, translated_text=translated, target_language=payload.target_language, tone=payload.tone, slang_breakdown=slang, provider=provider)

@app.get("/api/v1/abbreviations", response_model=list[AbbreviationOut])
def list_abbreviations(q: str | None = Query(default=None), limit: int = Query(default=100, ge=1, le=500), offset: int = Query(default=0, ge=0), db: Session = Depends(get_db)):
    stmt = select(ChatAbbreviation).order_by(ChatAbbreviation.short_form).offset(offset).limit(limit)
    if q:
        stmt = select(ChatAbbreviation).where(ChatAbbreviation.short_form.ilike(f"%{q}%") | ChatAbbreviation.full_form.ilike(f"%{q}%")).order_by(ChatAbbreviation.short_form).offset(offset).limit(limit)
    return db.scalars(stmt).all()

@app.post("/api/v1/abbreviations", response_model=AbbreviationOut, status_code=201)
def create_abbreviation(payload: AbbreviationCreate, db: Session = Depends(get_db)):
    row = ChatAbbreviation(short_form=payload.short_form.strip().lower(), full_form=payload.full_form.strip())
    db.add(row)
    try:
        db.commit(); db.refresh(row)
    except IntegrityError:
        db.rollback(); raise HTTPException(status_code=409, detail="short_form already exists")
    return row

@app.delete("/api/v1/abbreviations/{abbr_id}", status_code=204)
def delete_abbreviation(abbr_id: int, db: Session = Depends(get_db)):
    row = db.get(ChatAbbreviation, abbr_id)
    if not row: raise HTTPException(status_code=404, detail="Abbreviation not found")
    db.delete(row); db.commit()

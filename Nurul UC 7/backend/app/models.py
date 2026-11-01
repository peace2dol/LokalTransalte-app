from datetime import datetime
from sqlalchemy import DateTime, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column
from .database import Base

class ChatAbbreviation(Base):
    __tablename__ = "chat_abbreviations"
    abbr_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    short_form: Mapped[str] = mapped_column(String(50), unique=True, nullable=False, index=True)
    full_form: Mapped[str] = mapped_column(String(100), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

class SlangTerm(Base):
    __tablename__ = "slang_terms"
    slang_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    term: Mapped[str] = mapped_column(String(80), unique=True, nullable=False, index=True)
    meaning: Mapped[str] = mapped_column(String(180), nullable=False)
    usage_note: Mapped[str] = mapped_column(Text, nullable=False, default="")

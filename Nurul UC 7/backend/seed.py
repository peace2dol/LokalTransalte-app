import json
from pathlib import Path
from sqlalchemy import select
from app.database import Base, engine, SessionLocal
from app.models import ChatAbbreviation, SlangTerm

Base.metadata.create_all(bind=engine)
rows = json.loads((Path(__file__).parent / "data" / "seed.json").read_text(encoding="utf-8"))
# Keep first occurrence and trim accidental whitespace in seed keys.
unique = {}
for item in rows:
    key = item["short_form"].strip().lower()
    if key and key not in unique:
        unique[key] = item["full_form"].strip()
slang_rows = [
    ("lah", "partikel penegas", "Partikel percakapan yang memberi penegasan atau nada mesra; makna bergantung pada intonasi."),
    ("kot", "mungkin / agaknya", "Menunjukkan ketidakpastian atau andaian dalam perbualan santai."),
    ("weh", "panggilan tidak formal", "Digunakan untuk menarik perhatian rakan; sangat santai."),
    ("poyo", "berlagak / menunjuk-nunjuk", "Sindiran tidak formal terhadap seseorang yang dianggap menunjuk-nunjuk."),
    ("steady", "bagus / tenang", "Pujian atau galakan; boleh juga bermaksud kekal tenang."),
    ("gempak", "hebat / mengagumkan", "Ungkapan pujian tidak formal."),
    ("syok", "seronok", "Menggambarkan pengalaman yang menyeronokkan."),
    ("kantoi", "tertangkap / terbongkar", "Digunakan apabila sesuatu perbuatan atau rahsia diketahui orang lain."),
    ("tapau", "bungkus untuk dibawa pulang", "Dalam konteks makanan, bermaksud membungkus; dalam konteks lain boleh bermaksud mengalahkan."),
    ("cun", "cantik / menarik", "Pujian tidak formal, lazimnya tentang penampilan atau sesuatu yang menarik."),
]
with SessionLocal() as db:
    for short, full in unique.items():
        if not db.scalar(select(ChatAbbreviation).where(ChatAbbreviation.short_form == short)):
            db.add(ChatAbbreviation(short_form=short, full_form=full))
    for term, meaning, note in slang_rows:
        if not db.scalar(select(SlangTerm).where(SlangTerm.term == term)):
            db.add(SlangTerm(term=term, meaning=meaning, usage_note=note))
    db.commit()
print(f"Seed complete: {len(unique)} unique abbreviation entries; {len(slang_rows)} slang notes.")

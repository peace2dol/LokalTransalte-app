import re
from sqlalchemy import select
from sqlalchemy.orm import Session
from .models import ChatAbbreviation

# Match whole tokens only; preserve punctuation and original casing where practical.
def normalize_chat(text: str, db: Session) -> str:
    rows = db.scalars(select(ChatAbbreviation)).all()
    mapping = {r.short_form.casefold(): r.full_form for r in rows}
    if not mapping:
        return text
    pattern = re.compile(r"(?<![\w])(" + "|".join(map(re.escape, sorted(mapping, key=len, reverse=True))) + r")(?![\w])", re.IGNORECASE)
    return pattern.sub(lambda m: mapping[m.group(0).casefold()], text)

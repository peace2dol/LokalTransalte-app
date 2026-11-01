# LokalTranslator — Flutter + FastAPI + PostgreSQL

A modern Malay chat translation starter project. It includes a Flutter client, FastAPI REST API, PostgreSQL persistence, whole-token abbreviation normalization, slang context lookup, and an optional OpenAI-compatible LLM adapter.

## Included features

- Flutter home screen with English/Mandarin selector, casual/formal toggle, 5,000-character input, paste, clear, counter, and loading state.
- Translation result with copy, share, favorite storage, and normalized-text view.
- Slang breakdown cards with meaning and usage notes.
- FastAPI endpoints for translation and abbreviation CRUD/listing.
- PostgreSQL `chat_abbreviations` table matching the requested fields, plus a `slang_terms` context table.
- Seed script loads 300+ unique abbreviation/normalization entries and initial slang notes.
- Optional LLM adapter. Without provider credentials the API returns an explicit demo placeholder, not a fabricated translation.

## 1. Run the backend and database

Requirements: Docker Desktop with Docker Compose.

From this directory:

```bash
docker compose up --build
```

The API starts at `http://localhost:8000`. Interactive API docs: `http://localhost:8000/docs`.

Health check:

```bash
curl http://localhost:8000/health
```

The first startup creates the tables and seeds the abbreviation/slang data. To see the exact number of unique abbreviation entries, check the startup log from `seed.py`.

## 2. Enable real AI translation

Edit `backend/.env` and set values for an OpenAI-compatible Chat Completions endpoint:

```env
LLM_BASE_URL=https://your-provider.example/v1
LLM_API_KEY=your-secret-key
LLM_MODEL=your-model-name
```

Restart the API with `docker compose up -d --build api`. Keep API keys in environment variables; never place them in Flutter source code. Provider must support `/chat/completions` and JSON-object response mode. Confirm the provider's data handling and regional/privacy requirements before production use.

## 3. Run Flutter

Install Flutter SDK, then generate the native platform folders once (the starter keeps the repository compact):

```bash
cd mobile
flutter create . --project-name lokaltranslator
flutter pub get
flutter run
```

Default API URL is `http://10.0.2.2:8000` for the Android emulator. For iOS simulator use:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

For a physical phone, use your development computer's LAN IP, ensure both devices share a network, and configure the API host/firewall accordingly:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
```

Replace the sample IP with your computer's actual LAN IP. For production, use HTTPS and a deployed API hostname.

## 4. API examples

Translate:

```bash
curl -X POST http://localhost:8000/api/v1/translate \
  -H 'Content-Type: application/json' \
  -d '{"text":"xleh dtg skrg sbb tgh keje","target_language":"English","tone":"casual"}'
```

List abbreviations:

```bash
curl 'http://localhost:8000/api/v1/abbreviations?limit=50'
```

Add an abbreviation:

```bash
curl -X POST http://localhost:8000/api/v1/abbreviations \
  -H 'Content-Type: application/json' \
  -d '{"short_form":"otw","full_form":"dalam perjalanan"}'
```

Delete an abbreviation:

```bash
curl -X DELETE http://localhost:8000/api/v1/abbreviations/1
```

## 5. Database design

`chat_abbreviations`:

| Column | Type | Constraints |
|---|---|---|
| abbr_id | INTEGER | Primary key, identity/auto-increment |
| short_form | VARCHAR(50) | Unique, not null, indexed |
| full_form | VARCHAR(100) | Not null |
| created_at | TIMESTAMPTZ | Defaults to current timestamp |

`slang_terms` stores the contextual term, meaning, and usage note passed to the LLM. `backend/schema.sql` contains the corresponding SQL DDL.

## 6. Important implementation notes

- Normalization matches complete tokens only (word boundaries) to avoid replacing abbreviations inside longer words. Validate every seed mapping with native Malay speakers before production; short forms can be ambiguous across regions and contexts.
- Current normalizer is dictionary-based. A future enhancement should add per-entry confidence, region/register, and contextual disambiguation.
- Current favorite storage is local to the device via `shared_preferences`; user accounts and cloud sync are not included.
- The demo fallback is intentionally obvious. A real translation requires LLM credentials and an available provider.
- The 2.5-second response target is a performance goal, not a guarantee. Measure end-to-end latency with the chosen LLM, network, and device; tune timeouts, caching, and model choice.
- Before deployment add authentication, rate limiting, request logging with privacy controls, migrations (Alembic), automated tests, secure secret management, and HTTPS.

## Project layout

```text
lokaltranslator/
  backend/
    app/                 FastAPI routes, models, schemas, normalization, LLM adapter
    data/seed.json       abbreviation seed dictionary
    Dockerfile
    schema.sql
    seed.py
  mobile/
    lib/main.dart        Flutter UI and API integration
    pubspec.yaml
  docker-compose.yml
```

# Pronounce Perfect - Backend API

AI-powered pronunciation analysis API built with FastAPI and Whisper.

## Features

- Speech-to-text using OpenAI Whisper
- Pronunciation scoring (accuracy, fluency, intonation)
- Text alignment and mispronunciation detection
- RESTful API with FastAPI
- Docker-ready deployment

## Requirements

- Python 3.11+
- FFmpeg
- ~2GB RAM for Whisper base model

## Installation

1. Create virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

## Running Locally

```bash
# Development mode with auto-reload
uvicorn app.main:app --reload

# Production mode
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

API will be available at `http://localhost:8000`

## Docker Deployment

```bash
# Build image
docker build -t pronunciation-backend .

# Run container
docker run -p 8000:8000 pronunciation-backend
```

## API Documentation

Once running, visit:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## API Endpoints

### Health Check
```
GET /health
```

### Analyze Pronunciation
```
POST /api/analyze-pronunciation
Content-Type: multipart/form-data

Parameters:
- audio: WAV audio file
- reference_text: Expected text

Response:
{
  "transcript": "...",
  "score": 85,
  "mispronounced_words": ["word1", "word2"],
  "phoneme_errors": [...],
  "feedback": "...",
  "accuracy": 0.87,
  "fluency": 0.83,
  "intonation": 0.85
}
```

## Architecture

- `app/main.py` - FastAPI application
- `app/api/endpoints/` - API routes
- `app/services/` - AI services (Whisper, alignment, scoring)
- `app/models/` - Pydantic models

## AI Models

- **Whisper** (base model) - Speech-to-text transcription
- **Alignment Service** - Text comparison (simplified PoC)
- **Scoring Service** - Pronunciation metrics

## Notes

- Audio files are processed and immediately deleted
- No permanent audio storage
- First run will download Whisper model (~150MB)

## License

MIT

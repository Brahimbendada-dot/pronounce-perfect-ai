# Pronounce Perfect
## Proof of Concept (PoC) & Technical Specification

---

## 1. Overview
**Pronounce Perfect** is a mobile application designed to help users improve their English pronunciation through guided learning paths, voice recording, and AI-powered pronunciation analysis. This PoC describes a complete, buildable solution based on the provided UI/UX, implemented with **Flutter + GetX** and integrated with **open-source audio processing models**.

The document is intended to be used as:
- A **PoC specification** for Antigravity IDE / Cursor
- A **technical handoff document** for developers
- A **foundation for MVP → production** evolution

---

## 2. Goals of the PoC
- Validate the full pronunciation-learning flow end-to-end
- Demonstrate real audio processing using open-source AI
- Match the provided UI screens pixel-perfect
- Prove scalability and readiness for future ML improvements

---

## 3. Target Platforms
- **Mobile**: Android & iOS
- **Framework**: Flutter (latest stable)

---

## 4. Technology Stack

### 4.1 Mobile Application
- Flutter
- GetX (state management, routing, dependency injection)
- Audio recording & playback:
  - `record` or `flutter_sound`
  - `just_audio`
- Permissions:
  - `permission_handler`
- Backend communication:
  - `dio`

### 4.2 Backend & AI Processing
- Python
- FastAPI
- Docker (deployment-ready)
- Open-source speech models:
  - **Whisper** (Speech-to-Text)
  - **Montreal Forced Aligner (MFA)** or **Gentle** (phoneme alignment)
  - **CMU Pronouncing Dictionary**

### 4.3 Cloud Services
- Firebase Authentication
- Cloud Firestore
- Firebase Storage

---

## 5. Application Features (Based on UI)

### 5.1 Authentication
- Email & password login
- Google Sign-In
- Account creation
- Forgot password
- Persistent authentication state

### 5.2 Onboarding & Level Selection
- Welcome screen
- Choose English level:
  - Beginner
  - Intermediate
  - Advanced
- Level stored in Firestore

### 5.3 Subject Selection
- Daily Conversation
- Business English
- Academic English
- Travel English

### 5.4 Listen & Learn
- Sample audio playback
- Reference text display
- Progress indicator
- Call-to-action: record voice

### 5.5 Voice Recording
- Microphone permission handling
- Real-time recording UI
- Audio saved as `.wav`
- Upload to backend for processing

### 5.6 Pronunciation Analysis
- Animated “Analyzing” screen
- Real speech-to-text processing
- Phoneme-level comparison
- Performance scoring

### 5.7 Results & Feedback
- Overall pronunciation score (%)
- Text comparison (expected vs user speech)
- Mispronounced words
- Intonation & fluency feedback
- Retry recording

### 5.8 Profile & Progress
- Profile picture upload
- User statistics:
  - Lessons completed
  - Average pronunciation score
  - Vocabulary learned
- Edit profile
- Logout

---

## 6. System Architecture

### 6.1 Flutter Architecture (Feature-Based + Clean)
```
lib/
 ├── app/
 │    ├── routes/
 │    ├── bindings/
 │    └── theme/
 ├── modules/
 │    ├── auth/
 │    ├── onboarding/
 │    ├── level/
 │    ├── subjects/
 │    ├── learning/
 │    ├── recording/
 │    ├── analysis/
 │    └── profile/
 ├── services/
 │    ├── audio_service.dart
 │    ├── api_service.dart
 │    └── auth_service.dart
 ├── models/
 └── main.dart
```

Each module contains:
- `view`
- `controller` (GetX)
- `binding`
- `model`

---

### 6.2 Backend Architecture
```
backend/
 ├── app/
 │    ├── api/
 │    ├── services/
 │    ├── models/
 │    └── main.py
 ├── requirements.txt
 └── Dockerfile
```

---

## 7. Audio Processing Pipeline

### 7.1 Step-by-Step Flow
1. User records voice in Flutter
2. Audio converted to `.wav`
3. Audio uploaded to FastAPI backend
4. Whisper transcribes speech to text
5. Forced alignment with reference text
6. Phoneme-level comparison
7. Score computation
8. Structured feedback returned to mobile app

---

### 7.2 AI Models Used
- **Whisper (open-source)**
  - Model: `base` or `small`
  - Task: Speech-to-text

- **Montreal Forced Aligner / Gentle**
  - Task: Align spoken phonemes to reference text

- **CMU Pronouncing Dictionary**
  - Task: Expected phoneme generation

---

## 8. Pronunciation Scoring Logic (PoC)

### Metrics
- Accuracy score
- Fluency score
- Intonation score

### Final Score
```
final_score = (accuracy * 0.5) + (fluency * 0.3) + (intonation * 0.2)
```

---

## 9. API Specification

### Endpoint
```
POST /analyze-pronunciation
```

### Request
- Multipart form-data
  - `audio`: wav file
  - `reference_text`: string

### Response
```json
{
  "transcript": "string",
  "score": 78,
  "mispronounced_words": ["word1", "word2"],
  "phoneme_errors": [],
  "feedback": "Focus on vowel clarity and pacing"
}
```

---

## 10. UI & UX Guidelines
- Match provided designs pixel-perfect
- Purple primary color palette
- Rounded cards and buttons
- Smooth transitions
- Dark analysis screen
- iPhone 13/14 responsive layout

---

## 11. Non-Functional Requirements
- Clean, readable, maintainable code
- GetX reactive state only (no setState)
- Error handling and loading states
- Offline-safe UI
- Mock AI fallback if backend is unreachable

---

## 12. Deliverables (PoC)
- Flutter mobile application
- FastAPI AI backend
- Dockerized deployment
- Firebase integration
- Working pronunciation analysis pipeline

---

## 13. Future Enhancements
- Replace MFA with wav2vec2 phoneme scoring
- On-device inference (TensorFlow Lite)
- Personalized learning recommendations
- Multi-language support

---

## 14. Conclusion
This PoC demonstrates a complete, realistic pronunciation-learning system using modern Flutter architecture and open-source AI models. It is suitable for MVP validation, academic projects, and startup-level production planning.


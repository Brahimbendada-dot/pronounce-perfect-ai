from pydantic import BaseModel
from typing import List

class PhonemeError(BaseModel):
    word: str
    expected: str
    actual: str
    confidence: float

class AnalysisResponse(BaseModel):
    transcript: str
    score: int
    mispronounced_words: List[str]
    phoneme_errors: List[PhonemeError]
    feedback: str
    accuracy: float
    fluency: float
    intonation: float

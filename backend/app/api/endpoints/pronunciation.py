from fastapi import APIRouter, UploadFile, File, Form, HTTPException
import tempfile
import os
from pathlib import Path

from app.models.response_models import AnalysisResponse
from app.services.whisper_service import whisper_service
from app.services.alignment_service import alignment_service
from app.services.scoring_service import scoring_service

router = APIRouter()

@router.post("/analyze-pronunciation", response_model=AnalysisResponse)
async def analyze_pronunciation(
    audio: UploadFile = File(...),
    reference_text: str = Form(...)
):
    """
    Analyze pronunciation from uploaded audio file.
    
    - **audio**: WAV audio file
    - **reference_text**: The text that should have been spoken
    
    Returns pronunciation analysis with score and feedback.
    """
    temp_file_path = None
    
    try:
        # Validate audio file
        if not audio.filename.endswith(('.wav', '.WAV', '.mp3', '.MP3')):
            raise HTTPException(status_code=400, detail="Only WAV and MP3 files are supported")
        
        # Save uploaded file temporarily
        with tempfile.NamedTemporaryFile(delete=False, suffix='.wav') as temp_file:
            content = await audio.read()
            temp_file.write(content)
            temp_file_path = temp_file.name
        
        # Step 1: Transcribe audio using Whisper
        print("Transcribing audio...")
        transcription_result = whisper_service.transcribe(temp_file_path)
        transcript = transcription_result["text"]
        segments = transcription_result.get("segments", [])
        confidence = whisper_service.get_confidence(segments)
        
        print(f"Transcript: {transcript}")
        
        # Step 2: Align transcript with reference text
        print("Aligning text...")
        alignment_result = alignment_service.align_text(reference_text, transcript)
        mispronounced_words = alignment_result["mispronounced_words"]
        phoneme_errors = alignment_result["phoneme_errors"]
        similarity_score = alignment_result["similarity_score"]
        
        # Step 3: Calculate scores
        print("Calculating scores...")
        scores = scoring_service.calculate_scores(
            reference_text=reference_text,
            transcript_text=transcript,
            similarity_score=similarity_score,
            confidence=confidence,
            mispronounced_count=len(mispronounced_words)
        )
        
        # Step 4: Generate feedback
        feedback = scoring_service.generate_feedback(
            score=scores["score"],
            accuracy=scores["accuracy"],
            fluency=scores["fluency"],
            intonation=scores["intonation"],
            mispronounced_words=mispronounced_words
        )
        
        # Prepare response
        response = AnalysisResponse(
            transcript=transcript,
            score=scores["score"],
            mispronounced_words=mispronounced_words,
            phoneme_errors=phoneme_errors,
            feedback=feedback,
            accuracy=scores["accuracy"],
            fluency=scores["fluency"],
            intonation=scores["intonation"]
        )
        
        return response
        
    except Exception as e:
        print(f"Error in analyze_pronunciation: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")
    
    finally:
        # Clean up temporary file
        if temp_file_path and os.path.exists(temp_file_path):
            try:
                os.unlink(temp_file_path)
                print(f"Deleted temporary file: {temp_file_path}")
            except Exception as e:
                print(f"Failed to delete temp file: {e}")

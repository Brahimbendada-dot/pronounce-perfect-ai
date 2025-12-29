import whisper
import os
import tempfile

class WhisperService:
    def __init__(self, model_name="base"):
        """
        Initialize Whisper model.
        Available models: tiny, base, small, medium, large
        """
        print(f"Loading Whisper model: {model_name}...")
        self.model = whisper.load_model(model_name)
        print("Whisper model loaded successfully")

    def transcribe(self, audio_file_path: str) -> dict:
        """
        Transcribe audio file to text.
        
        Args:
            audio_file_path: Path to audio file
            
        Returns:
            dict with transcription results
        """
        try:
            result = self.model.transcribe(audio_file_path)
            return {
                "text": result["text"].strip(),
                "language": result.get("language", "en"),
                "segments": result.get("segments", [])
            }
        except Exception as e:
            raise Exception(f"Transcription failed: {str(e)}")

    def get_confidence(self, segments: list) -> float:
        """
        Calculate average confidence from segments.
        """
        if not segments:
            return 0.75  # Default confidence
        
        confidences = []
        for segment in segments:
            if "no_speech_prob" in segment:
                confidence = 1.0 - segment["no_speech_prob"]
                confidences.append(confidence)
        
        return sum(confidences) / len(confidences) if confidences else 0.75

# Initialize global instance
whisper_service = WhisperService(model_name="base")

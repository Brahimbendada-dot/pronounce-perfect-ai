import random

class ScoringService:
    def __init__(self):
        pass

    def calculate_scores(
        self,
        reference_text: str,
        transcript_text: str,
        similarity_score: float,
        confidence: float,
        mispronounced_count: int
    ) -> dict:
        """
        Calculate pronunciation scores.
        Formula: final_score = (accuracy * 0.5) + (fluency * 0.3) + (intonation * 0.2)
        """
        # Calculate accuracy based on text similarity
        accuracy = similarity_score * confidence
        accuracy = max(0.0, min(1.0, accuracy))
        
        # Calculate fluency (words spoken / words in reference, considering pauses)
        ref_word_count = len(reference_text.split())
        trans_word_count = len(transcript_text.split())
        fluency = min(trans_word_count / ref_word_count, 1.0) if ref_word_count > 0 else 0.0
        
        # Penalize for too many or too few words
        word_diff = abs(trans_word_count - ref_word_count)
        fluency_penalty = min(word_diff * 0.05, 0.3)
        fluency = max(0.0, fluency - fluency_penalty)
        
        # Calculate intonation (simplified - based on confidence and mispronunciation)
        intonation = confidence * (1.0 - (mispronounced_count * 0.05))
        intonation = max(0.0, min(1.0, intonation))
        
        # Add some controlled randomness for realistic variation
        accuracy += random.uniform(-0.05, 0.05)
        fluency += random.uniform(-0.05, 0.05)
        intonation += random.uniform(-0.05, 0.05)
        
        # Clamp values
        accuracy = max(0.0, min(1.0, accuracy))
        fluency = max(0.0, min(1.0, fluency))
        intonation = max(0.0, min(1.0, intonation))
        
        # Calculate final score
        final_score = (accuracy * 0.5) + (fluency * 0.3) + (intonation * 0.2)
        final_score = int(final_score * 100)
        
        return {
            "score": final_score,
            "accuracy": round(accuracy, 2),
            "fluency": round(fluency, 2),
            "intonation": round(intonation, 2)
        }

    def generate_feedback(
        self,
        score: int,
        accuracy: float,
        fluency: float,
        intonation: float,
        mispronounced_words: list
    ) -> str:
        """
        Generate personalized feedback based on scores.
        """
        feedback_parts = []
        
        # Overall performance
        if score >= 90:
            feedback_parts.append("Excellent pronunciation!")
        elif score >= 75:
            feedback_parts.append("Good job! Your pronunciation is quite clear.")
        elif score >= 60:
            feedback_parts.append("Not bad! There's room for improvement.")
        else:
            feedback_parts.append("Keep practicing! Pronunciation improves with regular practice.")
        
        # Accuracy feedback
        if accuracy < 0.7:
            feedback_parts.append("Focus on pronouncing each word clearly and correctly.")
        
        # Fluency feedback
        if fluency < 0.7:
            feedback_parts.append("Try to maintain a steady, natural pace while speaking.")
        elif fluency > 0.95:
            feedback_parts.append("Great speech rhythm!")
        
        # Intonation feedback
        if intonation < 0.7:
            feedback_parts.append("Work on your intonation and stress patterns.")
        
        # Specific words feedback
        if mispronounced_words:
            words_str = ", ".join(mispronounced_words[:3])
            feedback_parts.append(f"Pay special attention to: {words_str}.")
        
        # General encouragement
        if score < 75:
            feedback_parts.append("Keep practicing these phrases for better results!")
        
        return " ".join(feedback_parts)

# Initialize global instance
scoring_service = ScoringService()

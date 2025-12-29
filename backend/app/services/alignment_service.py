from difflib import SequenceMatcher
import re

class AlignmentService:
    def __init__(self):
        pass

    def align_text(self, reference_text: str, transcript_text: str) -> dict:
        """
        Align transcript with reference text and identify mispronounced words.
        For PoC, using simple text similarity comparison.
        In production, would use Montreal Forced Aligner or Gentle.
        """
        # Normalize text
        ref_words = self._normalize_text(reference_text).split()
        trans_words = self._normalize_text(transcript_text).split()
        
        # Find mispronounced words
        mispronounced = []
        phoneme_errors = []
        
        # Use sequence matcher to find differences
        matcher = SequenceMatcher(None, ref_words, trans_words)
        
        for tag, i1, i2, j1, j2 in matcher.get_opcodes():
            if tag == 'replace':
                # Words that were mispronounced or substituted
                for word in ref_words[i1:i2]:
                    if word not in mispronounced:
                        mispronounced.append(word)
                        phoneme_errors.append({
                            "word": word,
                            "expected": word,
                            "actual": " ".join(trans_words[j1:j2]) if j1 < j2 else "[missing]",
                            "confidence": 0.8
                        })
            elif tag == 'delete':
                # Words that were skipped
                for word in ref_words[i1:i2]:
                    if word not in mispronounced:
                        mispronounced.append(word)
                        phoneme_errors.append({
                            "word": word,
                            "expected": word,
                            "actual": "[skipped]",
                            "confidence": 0.9
                        })
        
        return {
            "mispronounced_words": mispronounced[:10],  # Limit to 10
            "phoneme_errors": phoneme_errors[:5],  # Limit to 5
            "similarity_score": matcher.ratio()
        }

    def _normalize_text(self, text: str) -> str:
        """
        Normalize text for comparison.
        """
        # Convert to lowercase
        text = text.lower()
        # Remove punctuation
        text = re.sub(r'[^\w\s]', '', text)
        # Remove extra whitespace
        text = ' '.join(text.split())
        return text

# Initialize global instance
alignment_service = AlignmentService()

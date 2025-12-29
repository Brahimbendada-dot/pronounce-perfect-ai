class AnalysisResultModel {
  final String transcript;
  final int score; // 0-100
  final List<String> mispronuncedWords;
  final List<PhonemeError> phonemeErrors;
  final String feedback;
  final double accuracy;
  final double fluency;
  final double intonation;

  AnalysisResultModel({
    required this.transcript,
    required this.score,
    required this.mispronuncedWords,
    required this.phonemeErrors,
    required this.feedback,
    required this.accuracy,
    required this.fluency,
    required this.intonation,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      transcript: json['transcript'] ?? '',
      score: json['score'] ?? 0,
      mispronuncedWords: List<String>.from(json['mispronounced_words'] ?? []),
      phonemeErrors: (json['phoneme_errors'] as List<dynamic>?)
              ?.map((e) => PhonemeError.fromJson(e))
              .toList() ??
          [],
      feedback: json['feedback'] ?? '',
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      fluency: (json['fluency'] ?? 0.0).toDouble(),
      intonation: (json['intonation'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transcript': transcript,
      'score': score,
      'mispronounced_words': mispronuncedWords,
      'phoneme_errors': phonemeErrors.map((e) => e.toJson()).toList(),
      'feedback': feedback,
      'accuracy': accuracy,
      'fluency': fluency,
      'intonation': intonation,
    };
  }
}

class PhonemeError {
  final String word;
  final String expected;
  final String actual;
  final double confidence;

  PhonemeError({
    required this.word,
    required this.expected,
    required this.actual,
    required this.confidence,
  });

  factory PhonemeError.fromJson(Map<String, dynamic> json) {
    return PhonemeError(
      word: json['word'] ?? '',
      expected: json['expected'] ?? '',
      actual: json['actual'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'expected': expected,
      'actual': actual,
      'confidence': confidence,
    };
  }
}

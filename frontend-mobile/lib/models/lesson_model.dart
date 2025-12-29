class LessonModel {
  final String id;
  final String subjectId;
  final String title;
  final String referenceText;
  final String audioUrl;
  final int duration; // in minutes
  final String difficulty; // beginner, intermediate, advanced
  
  LessonModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.referenceText,
    required this.audioUrl,
    required this.duration,
    required this.difficulty,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      subjectId: json['subjectId'],
      title: json['title'],
      referenceText: json['referenceText'],
      audioUrl: json['audioUrl'],
      duration: json['duration'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'title': title,
      'referenceText': referenceText,
      'audioUrl': audioUrl,
      'duration': duration,
      'difficulty': difficulty,
    };
  }
}

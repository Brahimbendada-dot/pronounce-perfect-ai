class SubjectModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int color; // Color value as int
  final List<LessonPreview> lessons;

  SubjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.lessons = const [],
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonPreview.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }
}

class LessonPreview {
  final String id;
  final String title;
  final int duration; // in minutes

  LessonPreview({
    required this.id,
    required this.title,
    required this.duration,
  });

  factory LessonPreview.fromJson(Map<String, dynamic> json) {
    return LessonPreview(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
    };
  }
}

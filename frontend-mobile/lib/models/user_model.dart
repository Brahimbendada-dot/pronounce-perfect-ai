class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String level; // beginner, intermediate, advanced
  final int lessonsCompleted;
  final double averageScore;
  final int vocabularyLearned;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.level = 'beginner',
    this.lessonsCompleted = 0,
    this.averageScore = 0.0,
    this.vocabularyLearned = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      level: json['level'] ?? 'beginner',
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
      averageScore: (json['averageScore'] ?? 0.0).toDouble(),
      vocabularyLearned: json['vocabularyLearned'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'level': level,
      'lessonsCompleted': lessonsCompleted,
      'averageScore': averageScore,
      'vocabularyLearned': vocabularyLearned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? level,
    int? lessonsCompleted,
    double? averageScore,
    int? vocabularyLearned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      level: level ?? this.level,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      averageScore: averageScore ?? this.averageScore,
      vocabularyLearned: vocabularyLearned ?? this.vocabularyLearned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Question {
  final int id;
  final int categoryId;
  final String questionText;
  final String? imageUrl;
  final int level;
  final int points;

  Question({
    required this.id,
    required this.categoryId,
    required this.questionText,
    this.imageUrl,
    this.level = 1,
    this.points = 0,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: (json['id'] as num).toInt(),
      categoryId: (json['category_id'] as num).toInt(),
      questionText: json['question_text'] as String,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      level: json['level'] != null ? (json['level'] as num).toInt() : 1,
      points: json['points'] != null ? (json['points'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'question_text': questionText,
      'image_url': imageUrl,
      'level': level,
      'points': points,
    };
  }

  Question copyWith({
    int? id,
    int? categoryId,
    String? questionText,
    String? imageUrl,
    int? level,
    int? points,
  }) {
    return Question(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      questionText: questionText ?? this.questionText,
      imageUrl: imageUrl ?? this.imageUrl,
      level: level ?? this.level,
      points: points ?? this.points,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Question && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

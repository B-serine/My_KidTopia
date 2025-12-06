// models/question.dart
class Question {
  final int? id;
  final int categoryId;
  final String questionText;
  final String? imageUrl;
  final int level;
  final int points;

  Question({
    this.id,
    required this.categoryId,
    required this.questionText,
    this.imageUrl,
    this.level = 1,
    this.points = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'question_text': questionText,
      'image_url': imageUrl,
      'level': level,
      'points': points,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      categoryId: map['category_id'] is int ? map['category_id'] : int.tryParse(map['category_id']?.toString() ?? '') ?? 0,
      questionText: map['question_text']?.toString() ?? '',
      imageUrl: map['image_url']?.toString(),
      level: map['level'] is int ? map['level'] : int.tryParse(map['level']?.toString() ?? '') ?? 1,
      points: map['points'] is int ? map['points'] : int.tryParse(map['points']?.toString() ?? '') ?? 1,
    );
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
}
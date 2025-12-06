// models/answer.dart
class Answer {
  final int? id;
  final int questionId;
  final String answerText;
  final bool isCorrect;
  final int displayOrder;

  Answer({
    this.id,
    required this.questionId,
    required this.answerText,
    this.isCorrect = false,
    this.displayOrder = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'answer_text': answerText,
      'is_correct': isCorrect ? 1 : 0,
      'display_order': displayOrder,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      questionId: map['question_id'] is int ? map['question_id'] : int.tryParse(map['question_id']?.toString() ?? '') ?? 0,
      answerText: map['answer_text']?.toString() ?? '',
      isCorrect: map['is_correct'] == 1,
      displayOrder: map['display_order'] is int ? map['display_order'] : int.tryParse(map['display_order']?.toString() ?? '') ?? 0,
    );
  }

  Answer copyWith({
    int? id,
    int? questionId,
    String? answerText,
    bool? isCorrect,
    int? displayOrder,
  }) {
    return Answer(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      answerText: answerText ?? this.answerText,
      isCorrect: isCorrect ?? this.isCorrect,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}
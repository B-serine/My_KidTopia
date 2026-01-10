class Answer {
  final int id;
  final int questionId;
  final String answerText;
  final bool isCorrect;
  final int displayOrder;

  Answer({
    required this.id,
    required this.questionId,
    required this.answerText,
    this.isCorrect = false,
    this.displayOrder = 0,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: (json['id'] as num).toInt(),
      questionId: (json['question_id'] as num).toInt(),
      answerText: json['answer_text'] as String,
      isCorrect: json['is_correct'] == true,
      displayOrder: json['display_order'] != null ? (json['display_order'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'answer_text': answerText,
      'is_correct': isCorrect,
      'display_order': displayOrder,
    };
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Answer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

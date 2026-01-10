// models/quiz.dart
// New Quiz model that combines question with 4 answers
// Supports multiple correct answers

class Quiz {
  final int? id;
  final int categoryId;
  final String questionText;
  final String? imageUrl; // Supabase storage URL
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;
  final List<int> correctAnswers; // List of correct answer indices (1-4)
  final int points;
  final int level;

  Quiz({
    this.id,
    required this.categoryId,
    required this.questionText,
    this.imageUrl,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.correctAnswers,
    this.points = 10,
    this.level = 1,
  });

  // Get all answers as a list
  List<String> get answers => [answer1, answer2, answer3, answer4];

  // Check if a specific answer index is correct (1-based)
  bool isAnswerCorrect(int answerIndex) {
    return correctAnswers.contains(answerIndex);
  }

  // Check if selected answers match all correct answers exactly
  bool checkAnswers(List<int> selectedAnswers) {
    if (selectedAnswers.length != correctAnswers.length) return false;
    final sortedSelected = List<int>.from(selectedAnswers)..sort();
    final sortedCorrect = List<int>.from(correctAnswers)..sort();
    for (int i = 0; i < sortedSelected.length; i++) {
      if (sortedSelected[i] != sortedCorrect[i]) return false;
    }
    return true;
  }

  // Check if it's a multiple choice question (more than one correct answer)
  bool get isMultipleChoice => correctAnswers.length > 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'question_text': questionText,
      'image_url': imageUrl,
      'answer1': answer1,
      'answer2': answer2,
      'answer3': answer3,
      'answer4': answer4,
      'correct_answers': correctAnswers,
      'points': points,
      'level': level,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    // Parse correct_answers - can be a List, PostgreSQL array string, or SQLite string
    List<int> parseCorrectAnswers(dynamic value) {
      if (value == null) return [1];
      if (value is List) {
        return value.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 1).toList();
      }
      if (value is String) {
        // Handle PostgreSQL array format: {1,2,3} or SQLite format: "1,2,3" or "1"
        final cleaned = value.replaceAll('{', '').replaceAll('}', '').trim();
        if (cleaned.isEmpty) return [1];
        return cleaned.split(',').map((e) => int.tryParse(e.trim()) ?? 1).toList();
      }
      if (value is int) {
        return [value];
      }
      return [1];
    }

    return Quiz(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      categoryId: map['category_id'] is int 
          ? map['category_id'] 
          : int.tryParse(map['category_id']?.toString() ?? '') ?? 0,
      questionText: map['question_text']?.toString() ?? '',
      imageUrl: map['image_url']?.toString(),
      answer1: map['answer1']?.toString() ?? '',
      answer2: map['answer2']?.toString() ?? '',
      answer3: map['answer3']?.toString() ?? '',
      answer4: map['answer4']?.toString() ?? '',
      correctAnswers: parseCorrectAnswers(map['correct_answers']),
      points: map['points'] is int 
          ? map['points'] 
          : int.tryParse(map['points']?.toString() ?? '') ?? 10,
      level: map['level'] is int 
          ? map['level'] 
          : int.tryParse(map['level']?.toString() ?? '') ?? 1,
    );
  }

  Quiz copyWith({
    int? id,
    int? categoryId,
    String? questionText,
    String? imageUrl,
    String? answer1,
    String? answer2,
    String? answer3,
    String? answer4,
    List<int>? correctAnswers,
    int? points,
    int? level,
  }) {
    return Quiz(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      questionText: questionText ?? this.questionText,
      imageUrl: imageUrl ?? this.imageUrl,
      answer1: answer1 ?? this.answer1,
      answer2: answer2 ?? this.answer2,
      answer3: answer3 ?? this.answer3,
      answer4: answer4 ?? this.answer4,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      points: points ?? this.points,
      level: level ?? this.level,
    );
  }

  @override
  String toString() {
    return 'Quiz(id: $id, question: $questionText, correctAnswers: $correctAnswers)';
  }
}

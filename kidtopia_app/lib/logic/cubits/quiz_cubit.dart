import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/question.dart';
import '../../data/models/answer.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/answer_repository.dart';

// ==================== STATES ====================
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizReady extends QuizState {
  final List<Question> questions;
  final Map<int, List<Answer>> answersMap;
  final int currentIndex;
  final int score;
  final int? selectedAnswerId;
  final bool answered;
  final bool? lastAnswerCorrect;

  QuizReady({
    required this.questions,
    required this.answersMap,
    this.currentIndex = 0,
    this.score = 0,
    this.selectedAnswerId,
    this.answered = false,
    this.lastAnswerCorrect,
  });

  Question get currentQuestion => questions[currentIndex];
  List<Answer> get currentAnswers => answersMap[currentQuestion.id] ?? [];
  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentIndex >= questions.length - 1;

  QuizReady copyWith({
    List<Question>? questions,
    Map<int, List<Answer>>? answersMap,
    int? currentIndex,
    int? score,
    int? selectedAnswerId,
    bool? answered,
    bool? lastAnswerCorrect,
  }) {
    return QuizReady(
      questions: questions ?? this.questions,
      answersMap: answersMap ?? this.answersMap,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      selectedAnswerId: selectedAnswerId ?? this.selectedAnswerId,
      answered: answered ?? this.answered,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
    );
  }
}

class QuizCompleted extends QuizState {
  final int finalScore;
  final int totalQuestions;
  final int correctAnswers;

  QuizCompleted({
    required this.finalScore,
    required this.totalQuestions,
    required this.correctAnswers,
  });

  int get starCount {
    final percentage = (correctAnswers / totalQuestions) * 100;
    if (percentage >= 80) return 3;
    if (percentage >= 50) return 2;
    if (percentage >= 30) return 1;
    return 0;
  }
}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}

// ==================== CUBIT ====================
class QuizCubit extends Cubit<QuizState> {
  final QuestionRepository _questionRepository;
  final AnswerRepository _answerRepository;
  int _correctCount = 0;

  QuizCubit(this._questionRepository, this._answerRepository)
    : super(QuizInitial());

  Future<void> loadQuiz(int categoryId, {int limit = 10}) async {
    emit(QuizLoading());
    _correctCount = 0;
    try {
      final questions = await _questionRepository.getRandomQuestions(
        categoryId,
        limit,
      );

      // Require exactly `limit` questions for a full quiz.
      if (questions.length < limit) {
        emit(QuizError('Not enough questions for this category (need $limit)'));
        return;
      }

      // Shuffle questions
      questions.shuffle();

      final Map<int, List<Answer>> answersMap = {};
      for (final question in questions) {
        final answers = await _answerRepository.getByQuestion(question.id!);
        // Shuffle answers for each question
        answers.shuffle();
        answersMap[question.id!] = answers;
      }

      emit(QuizReady(questions: questions, answersMap: answersMap));
    } catch (e) {
      emit(QuizError('Failed to load quiz: ${e.toString()}'));
    }
  }

  void selectAnswer(int answerId) {
    final currentState = state;
    if (currentState is QuizReady && !currentState.answered) {
      emit(currentState.copyWith(selectedAnswerId: answerId));
    }
  }

  Future<void> checkAnswer() async {
    final currentState = state;
    if (currentState is! QuizReady || currentState.selectedAnswerId == null)
      return;

    try {
      final isCorrect = await _answerRepository.isCorrect(
        currentState.selectedAnswerId!,
      );
      int newScore = currentState.score;

      if (isCorrect) {
        newScore += currentState.currentQuestion.points;
        _correctCount++;
      }

      emit(
        currentState.copyWith(
          answered: true,
          score: newScore,
          lastAnswerCorrect: isCorrect,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 1200));

      if (currentState.isLastQuestion) {
        emit(
          QuizCompleted(
            finalScore: newScore,
            totalQuestions: currentState.totalQuestions,
            correctAnswers: _correctCount,
          ),
        );
      } else {
        emit(
          QuizReady(
            questions: currentState.questions,
            answersMap: currentState.answersMap,
            currentIndex: currentState.currentIndex + 1,
            score: newScore,
            selectedAnswerId: null,
            answered: false,
          ),
        );
      }
    } catch (e) {
      emit(QuizError('Failed to check answer: ${e.toString()}'));
    }
  }

  void resetQuiz() {
    _correctCount = 0;
    emit(QuizInitial());
  }

  int get correctCount => _correctCount;
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/quiz.dart';
import '../../data/repositories/quiz_repository.dart';

// ==================== STATES ====================
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizReady extends QuizState {
  final List<Quiz> quizzes;
  final int currentIndex;
  final int score;
  final Set<int> selectedAnswers; // Set of selected answer indices (1-4)
  final bool answered;
  final bool? lastAnswerCorrect;

  QuizReady({
    required this.quizzes,
    this.currentIndex = 0,
    this.score = 0,
    Set<int>? selectedAnswers,
    this.answered = false,
    this.lastAnswerCorrect,
  }) : selectedAnswers = selectedAnswers ?? {};

  Quiz get currentQuiz => quizzes[currentIndex];
  int get totalQuestions => quizzes.length;
  bool get isLastQuestion => currentIndex >= quizzes.length - 1;
  
  // Check if current question has multiple correct answers
  bool get isMultipleChoice => currentQuiz.isMultipleChoice;

  QuizReady copyWith({
    List<Quiz>? quizzes,
    int? currentIndex,
    int? score,
    Set<int>? selectedAnswers,
    bool? answered,
    bool? lastAnswerCorrect,
  }) {
    return QuizReady(
      quizzes: quizzes ?? this.quizzes,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
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
  final QuizRepository _quizRepository;
  int _correctCount = 0;

  QuizCubit(this._quizRepository) : super(QuizInitial());

  Future<void> loadQuiz(int categoryId, {int limit = 10}) async {
    emit(QuizLoading());
    _correctCount = 0;
    
    try {
      // Fetch random quizzes from Supabase
      final quizzes = await _quizRepository.getRandomQuizzes(
        categoryId,
        limit: limit,
      );

      // Require at least some questions for a quiz
      if (quizzes.isEmpty) {
        emit(QuizError('No questions available for this category'));
        return;
      }

      // If we have fewer than limit, that's okay - use what we have
      if (quizzes.length < limit) {
        print('Note: Only ${quizzes.length} questions available (requested $limit)');
      }

      // Shuffle questions for variety
      quizzes.shuffle();

      emit(QuizReady(quizzes: quizzes));
    } catch (e) {
      emit(QuizError('Failed to load quiz: ${e.toString()}'));
    }
  }

  // Toggle answer selection (for multiple choice)
  void toggleAnswer(int answerIndex) {
    final currentState = state;
    if (currentState is QuizReady && !currentState.answered) {
      final newSelected = Set<int>.from(currentState.selectedAnswers);
      
      if (currentState.isMultipleChoice) {
        // Multiple choice - toggle selection
        if (newSelected.contains(answerIndex)) {
          newSelected.remove(answerIndex);
        } else {
          newSelected.add(answerIndex);
        }
      } else {
        // Single choice - replace selection
        newSelected.clear();
        newSelected.add(answerIndex);
      }
      
      emit(currentState.copyWith(selectedAnswers: newSelected));
    }
  }

  // Select single answer (for backward compatibility)
  void selectAnswer(int answerIndex) {
    final currentState = state;
    if (currentState is QuizReady && !currentState.answered) {
      final newSelected = <int>{answerIndex};
      emit(currentState.copyWith(selectedAnswers: newSelected));
    }
  }

  Future<void> checkAnswer() async {
    final currentState = state;
    if (currentState is! QuizReady || currentState.selectedAnswers.isEmpty) {
      return;
    }

    try {
      final quiz = currentState.currentQuiz;
      final selectedList = currentState.selectedAnswers.toList();
      
      // Check if selected answers match correct answers
      final isCorrect = quiz.checkAnswers(selectedList);
      int newScore = currentState.score;

      if (isCorrect) {
        newScore += quiz.points;
        _correctCount++;
      }

      emit(
        currentState.copyWith(
          answered: true,
          score: newScore,
          lastAnswerCorrect: isCorrect,
        ),
      );

      // Wait before moving to next question
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
            quizzes: currentState.quizzes,
            currentIndex: currentState.currentIndex + 1,
            score: newScore,
            selectedAnswers: {},
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

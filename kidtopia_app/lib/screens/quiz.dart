import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../assets/app_colors/app_colors.dart';
import '../logic/cubits/quiz_cubit.dart';
import '../logic/cubits/auth_cubit.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is QuizCompleted) {
          // Update user score in database
          context.read<AuthCubit>().updateUserScore(state.finalScore);
          // Navigate to score screen
          Navigator.pushReplacementNamed(context, '/score');
        }
      },
      builder: (context, state) {
        // Loading state - fetching from database
        if (state is QuizLoading) {
          return Scaffold(
            backgroundColor: brandBackground,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: brandPurple),
                  const SizedBox(height: 16),
                  Text('Loading questions from database...', style: TextStyle(color: brandTextLight, fontSize: 16)),
                ],
              ),
            ),
          );
        }

        // Error state - no questions found in database
        if (state is QuizError) {
          return Scaffold(
            backgroundColor: brandBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: brandTextDark),
                onPressed: () {
                  context.read<QuizCubit>().resetQuiz();
                  Navigator.pop(context);
                },
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.quiz_outlined, size: 80, color: brandTextLight.withOpacity(0.5)),
                    const SizedBox(height: 24),
                    Text(
                      'No Questions Available',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: brandTextDark),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: TextStyle(color: brandTextLight, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Questions need to be added to the database for this category.',
                      style: TextStyle(color: brandTextLight, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<QuizCubit>().resetQuiz();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Choose Another Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPurple,
                        foregroundColor: brandWhite,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Quiz ready state - questions fetched from database
        if (state is QuizReady) {
          final question = state.currentQuestion;
          final answers = state.currentAnswers;
          final progress = (state.currentIndex + 1) / state.totalQuestions;

          return Scaffold(
            backgroundColor: brandBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close, color: brandTextDark),
                onPressed: () {
                  context.read<QuizCubit>().resetQuiz();
                  Navigator.pop(context);
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Progress indicator
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 8,
                      decoration: BoxDecoration(
                        color: brandPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: brandPurple,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Score badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: brandYellow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text('${state.score}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Question number
                    Text(
                      'Question ${state.currentIndex + 1} of ${state.totalQuestions}',
                      style: TextStyle(color: brandTextLight, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Question image from database
                    if (question.imageUrl != null && question.imageUrl!.isNotEmpty)
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            question.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: brandPurple.withOpacity(0.1),
                              child: Center(
                                child: Icon(Icons.image_not_supported, size: 48, color: brandPurple.withOpacity(0.5)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Question text from database
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: brandWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            question.questionText,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: brandTextDark),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: brandPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+${question.points} points',
                              style: TextStyle(color: brandPurple, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Answer buttons from database
                    Expanded(
                      child: answers.isEmpty
                          ? Center(
                              child: Text(
                                'No answers found for this question',
                                style: TextStyle(color: brandTextLight),
                              ),
                            )
                          : ListView.builder(
                              itemCount: answers.length,
                              itemBuilder: (context, index) {
                                final answer = answers[index];
                                final isSelected = state.selectedAnswerId == answer.id;
                                final isAnswered = state.answered;
                                final isCorrect = answer.isCorrect;

                                Color bgColor = brandWhite;
                                Color borderColor = brandTextLight.withOpacity(0.3);
                                Color textColor = brandTextDark;

                                if (isAnswered) {
                                  if (isCorrect) {
                                    bgColor = Colors.green.withOpacity(0.2);
                                    borderColor = Colors.green;
                                    textColor = Colors.green.shade700;
                                  } else if (isSelected && !isCorrect) {
                                    bgColor = brandRed.withOpacity(0.2);
                                    borderColor = brandRed;
                                    textColor = brandRed;
                                  }
                                } else if (isSelected) {
                                  bgColor = brandPurple.withOpacity(0.1);
                                  borderColor = brandPurple;
                                  textColor = brandPurple;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: GestureDetector(
                                    onTap: isAnswered ? null : () => context.read<QuizCubit>().selectAnswer(answer.id!),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: borderColor, width: 2),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: isSelected ? borderColor : brandTextLight.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: isAnswered && isCorrect
                                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                                  : isAnswered && isSelected && !isCorrect
                                                      ? const Icon(Icons.close, color: Colors.white, size: 20)
                                                      : Text(
                                                          String.fromCharCode(65 + index),
                                                          style: TextStyle(
                                                            color: isSelected ? Colors.white : brandTextLight,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              answer.answerText,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    // Check Answer button
                    if (!state.answered && state.selectedAnswerId != null)
                      ElevatedButton(
                        onPressed: () => context.read<QuizCubit>().checkAnswer(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandPurple,
                          foregroundColor: brandWhite,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                        ),
                        child: const Text('Check Answer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),

                    // Feedback after answering
                    if (state.answered)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: state.lastAnswerCorrect == true
                              ? Colors.green.withOpacity(0.1)
                              : brandRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              state.lastAnswerCorrect == true ? Icons.check_circle : Icons.cancel,
                              color: state.lastAnswerCorrect == true ? Colors.green : brandRed,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.lastAnswerCorrect == true ? 'Correct! +${question.points} points' : 'Wrong answer!',
                              style: TextStyle(
                                color: state.lastAnswerCorrect == true ? Colors.green : brandRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }

        // Initial state - no quiz loaded yet
        return Scaffold(
          backgroundColor: brandBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: brandTextDark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz, size: 80, color: brandPurple.withOpacity(0.5)),
                  const SizedBox(height: 24),
                  Text(
                    'Ready to Play?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: brandTextDark),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select a category to start the quiz',
                    style: TextStyle(color: brandTextLight, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.category),
                    label: const Text('Choose Category'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandPurple,
                      foregroundColor: brandWhite,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

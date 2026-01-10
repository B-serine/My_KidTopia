import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../assets/app_colors/app_colors.dart';
import '../logic/cubits/quiz_cubit.dart';
import '../logic/cubits/auth_cubit.dart';
import '../l10n/app_localizations.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<QuizCubit, QuizState>(
      listener: (context, state) {
        print('🔵 QuizScreen listener - State: $state');

        if (state is QuizCompleted) {
          print('✅ Quiz Completed!');
          print('   Final Score: ${state.finalScore}');
          print('   Correct Answers: ${state.correctAnswers}');
          print('   Total Questions: ${state.totalQuestions}');

          // Update user score in database
          context.read<AuthCubit>().updateUserScore(state.finalScore);

          print('🚀 Navigating to /score with arguments...');

          // Pass quiz results as navigation arguments
          Navigator.pushReplacementNamed(
            context,
            '/score',
            arguments: {
              'finalScore': state.finalScore,
              'totalQuestions': state.totalQuestions,
              'correctAnswers': state.correctAnswers,
              'starCount': state.starCount,
            },
          );
        }
      },
      builder: (context, state) {
        if (state is QuizLoading) {
          return Scaffold(
            backgroundColor: brandBackground,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: brandPurple),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loadingQuestions,
                    style: TextStyle(color: brandTextLight, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

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
                    Icon(
                      Icons.quiz_outlined,
                      size: 80,
                      color: brandTextLight.withOpacity(0.5),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.noQuestionsAvailable,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: brandTextDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: TextStyle(color: brandTextLight, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.questionsNeeded,
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
                      label: Text(l10n.chooseAnotherCategory),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPurple,
                        foregroundColor: brandWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is QuizReady) {
          final quiz = state.currentQuiz;
          final answers = quiz.answers;
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: brandYellow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${state.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question number and multiple choice indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.question} ${state.currentIndex + 1}/${state.totalQuestions}',
                          style: TextStyle(
                            color: brandTextLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (state.isMultipleChoice)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: brandPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Multiple answers',
                              style: TextStyle(
                                color: brandPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Question image (if available)
                    if (quiz.imageUrl != null && quiz.imageUrl!.isNotEmpty)
                      Container(
                        height: 180,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: brandWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: quiz.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: brandPurple,
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: brandTextLight,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Question text
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: brandWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        quiz.questionText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: brandTextDark,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Answers list
                    Expanded(
                      child: ListView.builder(
                        itemCount: answers.length,
                        itemBuilder: (context, index) {
                          final answerIndex = index + 1; // 1-based index
                          final answerText = answers[index];
                          final isSelected = state.selectedAnswers.contains(answerIndex);
                          final isAnswered = state.answered;
                          final isCorrect = quiz.isAnswerCorrect(answerIndex);

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
                              onTap: isAnswered
                                  ? null
                                  : () => context
                                      .read<QuizCubit>()
                                      .toggleAnswer(answerIndex),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? borderColor
                                            : brandTextLight.withOpacity(0.1),
                                        shape: state.isMultipleChoice
                                            ? BoxShape.rectangle
                                            : BoxShape.circle,
                                        borderRadius: state.isMultipleChoice
                                            ? BorderRadius.circular(6)
                                            : null,
                                      ),
                                      child: Center(
                                        child: isAnswered && isCorrect
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 20,
                                              )
                                            : isAnswered &&
                                                    isSelected &&
                                                    !isCorrect
                                                ? const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )
                                                : isSelected &&
                                                        state.isMultipleChoice
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 18,
                                                      )
                                                    : Text(
                                                        String.fromCharCode(
                                                          65 + index,
                                                        ),
                                                        style: TextStyle(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : brandTextLight,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        answerText,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
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
                    if (!state.answered && state.selectedAnswers.isNotEmpty)
                      ElevatedButton(
                        onPressed: () =>
                            context.read<QuizCubit>().checkAnswer(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandPurple,
                          foregroundColor: brandWhite,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          l10n.checkAnswer,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Result feedback
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
                              state.lastAnswerCorrect == true
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: state.lastAnswerCorrect == true
                                  ? Colors.green
                                  : brandRed,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.lastAnswerCorrect == true
                                  ? l10n.correctAnswer(quiz.points)
                                  : l10n.wrongAnswer,
                              style: TextStyle(
                                color: state.lastAnswerCorrect == true
                                    ? Colors.green
                                    : brandRed,
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

        // Default state (QuizInitial)
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
                  Icon(
                    Icons.quiz,
                    size: 80,
                    color: brandPurple.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.readyToPlay,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: brandTextDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.categoriesWillAppear,
                    style: TextStyle(color: brandTextLight, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.category),
                    label: Text(l10n.chooseCategory),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandPurple,
                      foregroundColor: brandWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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

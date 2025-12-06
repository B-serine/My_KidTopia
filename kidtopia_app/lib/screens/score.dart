import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../assets/app_colors/app_colors.dart';
import '../logic/cubits/quiz_cubit.dart';
import '../logic/cubits/auth_cubit.dart';
import '../l10n/app_localizations.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _countdown = 5;
  Timer? _timer;

  // Store the quiz results from arguments
  int earnedPoints = 0;
  int totalQuestions = 0;
  int correctAnswers = 0;
  int starCount = 0;

  final List<String> _gameRoutes = [
    '/food_memory_game',
    '/matching_game',
    '/memory_card_game',
    '/pet_feeding_game',
    '/rainbow_monster_game',
    '/water_sort_game',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  
 @override
void didChangeDependencies() {
  super.didChangeDependencies();
  
  print('📊 ScoreScreen - didChangeDependencies called');
  
  // Get arguments and extract quiz results
  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  
  print('📦 Arguments received: $args');
  
  if (args != null) {
    earnedPoints = args['finalScore'] ?? 0;
    totalQuestions = args['totalQuestions'] ?? 0;
    correctAnswers = args['correctAnswers'] ?? 0;
    starCount = args['starCount'] ?? 0;
    
    print('✅ Using arguments:');
    print('   Earned Points: $earnedPoints');
    print('   Total Questions: $totalQuestions');
    print('   Correct Answers: $correctAnswers');
    print('   Star Count: $starCount');
  } else {
    print('⚠️ No arguments found, trying QuizCubit...');
    // Fallback: try to get from QuizCubit
    final quizState = context.read<QuizCubit>().state;
    print('   QuizCubit state: $quizState');
    
    if (quizState is QuizCompleted) {
      earnedPoints = quizState.finalScore;
      totalQuestions = quizState.totalQuestions;
      correctAnswers = quizState.correctAnswers;
      starCount = quizState.starCount;
      
      print('   Using QuizCubit data');
    } else {
      print('   ❌ QuizCubit is not QuizCompleted!');
    }
  }
  
  // Start countdown if earned reward
  if (correctAnswers >= 7 && _timer == null) {
    print('⏰ Starting countdown...');
    _startCountdown();
  } else {
    print('⏰ No countdown (correct answers: $correctAnswers)');
  }
}

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        if (mounted) {
          setState(() => _countdown--);
        }
      } else {
        timer.cancel();
        if (correctAnswers >= 7) {
          _navigateToRandomGame();
        }
      }
    });
  }

  void _navigateToRandomGame() {
    if (!mounted) return;
    final randomRoute = _gameRoutes[Random().nextInt(_gameRoutes.length)];
    context.read<QuizCubit>().resetQuiz();
    Navigator.pushReplacementNamed(context, randomRoute);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        int totalScore = 0;
        if (authState is AuthAuthenticated) {
          totalScore = authState.user.totalScore;
        }

        return Scaffold(
          backgroundColor: brandBackground,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getResultTitle(starCount, l10n),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: brandPurple,
                      ),
                    ),
                    const SizedBox(height: 24),

                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final isEarned = index < starCount;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              isEarned
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 60,
                              color: isEarned
                                  ? brandYellow
                                  : brandTextLight.withOpacity(0.3),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: brandWhite,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: Colors.green,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+$earnedPoints',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.pointsEarned,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: brandTextLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(color: brandTextLight.withOpacity(0.2)),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _StatItem(
                                icon: Icons.check_circle,
                                color: Colors.green,
                                value: '$correctAnswers/$totalQuestions',
                                label: l10n.correct,
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: brandTextLight.withOpacity(0.2),
                              ),
                              _StatItem(
                                icon: Icons.stars,
                                color: brandYellow,
                                value: '$totalScore',
                                label: l10n.totalScore,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (correctAnswers >= 7)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: brandPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer, color: brandPurple, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.nextGameIn(_countdown),
                              style: TextStyle(
                                color: brandPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.scoreToUnlock,
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _timer?.cancel();
                              context.read<QuizCubit>().resetQuiz();
                              Navigator.pushReplacementNamed(
                                context,
                                '/categories',
                              );
                            },
                            icon: const Icon(Icons.replay),
                            label: Text(l10n.playAgain),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: brandPurple,
                              side: BorderSide(color: brandPurple, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: (correctAnswers >= 7)
                                ? () {
                                    _timer?.cancel();
                                    _navigateToRandomGame();
                                  }
                                : null,
                            icon: const Icon(Icons.skip_next),
                            label: Text(
                              correctAnswers >= 7 ? l10n.nextNow : l10n.noReward,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: correctAnswers >= 7
                                  ? brandPurple
                                  : Colors.grey.shade300,
                              foregroundColor: correctAnswers >= 7
                                  ? brandWhite
                                  : brandTextLight,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextButton.icon(
                      onPressed: () {
                        _timer?.cancel();
                        context.read<QuizCubit>().resetQuiz();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      icon: Icon(Icons.home, color: brandTextLight),
                      label: Text(
                        l10n.goHome,
                        style: TextStyle(color: brandTextLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getResultTitle(int stars, AppLocalizations l10n) {
    switch (stars) {
      case 3:
        return l10n.scoreScreenTitle;
      case 2:
        return l10n.greatJob;
      case 1:
        return l10n.goodTry;
      default:
        return l10n.keepPracticing;
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: brandTextDark,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: brandTextLight)),
      ],
    );
  }
}
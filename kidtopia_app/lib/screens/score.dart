import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../assets/app_colors/app_colors.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final int _earnedPoints = 80;
  final int _starCount = 2; // 2 out of 3 stars earned
  int _countdown = 5;
  late Timer _redirectTimer;
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startRedirectTimer();
    _startCountdownTimer();
    _animateStars();
  }

  void _startRedirectTimer() {
    _redirectTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _navigateToRandomGame();
      }
    });
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdown > 1) {
            _countdown--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  void _navigateToRandomGame() {
    final games = [
      '/food_memory_game',
      '/matching_game',
      '/memory_card_game',
      '/pet_feeding_game',
      '/rainbow_monster_game',
      '/water_sort_game',
    ];

    final random = Random();
    final randomGame = games[random.nextInt(games.length)];

    Navigator.pushReplacementNamed(context, randomGame);
  }

  void _animateStars() {
    // Animate star filling
    for (int i = 0; i <= 2; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        if (mounted) {
          setState(() {
            if (i < _starCount) {
              // Star becomes filled
            }
          });
        }
      });
    }
  }

  void _handleManualNext() {
    // Cancel auto-redirect and navigate immediately
    _redirectTimer.cancel();
    _countdownTimer.cancel();
    _navigateToRandomGame();
  }

  void _handlePlayAgain() {
    // Cancel auto-redirect and go back to restart current game
    _redirectTimer.cancel();
    _countdownTimer.cancel();
    Navigator.pop(context); // Go back to restart the current game
  }

  @override
  void dispose() {
    _redirectTimer.cancel();
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandBackground,
      appBar: AppBar(
        backgroundColor: brandBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: brandTextLight),
          onPressed: () {
            _redirectTimer.cancel();
            _countdownTimer.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Title
              Text(
                'Nice Work!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: brandTextDark,
                ),
              ),

              const SizedBox(height: 40),

              // Success Icon with circles
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer circle
                  AnimatedContainer(
                    width: 140,
                    height: 140,
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: brandPurple.withOpacity(0.1),
                    ),
                  ),
                  // Middle circle
                  AnimatedContainer(
                    width: 110,
                    height: 110,
                    duration: const Duration(milliseconds: 700),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: brandPurple.withOpacity(0.3),
                    ),
                  ),
                  // Inner circle with checkmark
                  AnimatedContainer(
                    width: 80,
                    height: 80,
                    duration: const Duration(milliseconds: 900),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: brandPurple,
                    ),
                    child: Icon(Icons.check, color: brandWhite, size: 48),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStar(0),
                  const SizedBox(width: 8),
                  _buildStar(1),
                  const SizedBox(width: 8),
                  _buildStar(2),
                ],
              ),

              const SizedBox(height: 24),

              // Points earned
              Text(
                'You Earned $_earnedPoints pts',
                style: TextStyle(
                  fontSize: 18,
                  color: brandTextDark,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Loading indicator and countdown
              Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(brandPurple),
                  ),

                  const SizedBox(height: 16),

                  // Redirecting text with countdown
                  Text(
                    'Loading next game in $_countdown...',
                    style: TextStyle(fontSize: 16, color: brandTextLight),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Manual navigation buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handlePlayAgain,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: brandPurple,
                        side: BorderSide(color: brandPurple, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Play Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleManualNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPurple,
                        foregroundColor: brandWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Next Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Progress indicator
              Container(
                width: 100,
                height: 4,
                decoration: BoxDecoration(
                  color: brandPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStar(int index) {
    bool isFilled = index < _starCount;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500 + (index * 200)),
      child: Icon(
        Icons.star,
        color: isFilled ? brandPurple : brandTextLight.withOpacity(0.3),
        size: 40,
      ),
    );
  }
}

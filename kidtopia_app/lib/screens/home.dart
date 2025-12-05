import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../assets/app_colors/app_colors.dart';
import '../logic/cubits/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Get user data from state
        String username = 'Guest';
        int score = 0;

        if (state is AuthAuthenticated) {
          username = state.user.name;
          score = state.user.totalScore;
        }

        return Scaffold(
          backgroundColor: brandBackground,
          body: Column(
            children: [
              // Header with user info
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User profile button
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/profile'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: brandTextDark,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: brandPurple,
                            size: 28,
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              username,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Score badge
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
                            size: 24,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$score',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Game icon
                        Container(
                          width: 224,
                          height: 224,
                          decoration: BoxDecoration(
                            color: brandPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.games,
                            size: 100,
                            color: brandPurple,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Welcome text
                        Text(
                          'Ready to Play?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: brandTextDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Show us your powers $username!",
                          style: TextStyle(fontSize: 18, color: brandTextLight),
                        ),
                        const SizedBox(height: 32),

                        // Let's Go button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            minimumSize: const Size(200, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 8,
                            shadowColor: brandPurple.withAlpha(80),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/categories'),
                          child: const Text(
                            "Let's Go",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

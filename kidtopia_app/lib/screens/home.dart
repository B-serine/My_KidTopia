import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../assets/app_colors/app_colors.dart';
import '../logic/cubits/auth_cubit.dart';
import '../logic/cubits/locale_cubit.dart';
import '../l10n/app_localizations.dart';
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

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.language, color: brandPurple, size: 28),
            const SizedBox(width: 8),
            Text(l10n.selectLanguage),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(dialogContext, 'en', l10n.english, '🇬🇧'),
            const SizedBox(height: 12),
            _buildLanguageOption(dialogContext, 'fr', l10n.french, '🇫🇷'),
            const SizedBox(height: 12),
            _buildLanguageOption(dialogContext, 'ar', l10n.arabic, '🇸🇦'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext dialogContext, String code, String name, String flag) {
    final currentLocale = context.read<LocaleCubit>().state;
    final isSelected = currentLocale.languageCode == code;
    
    return GestureDetector(
      onTap: () {
        context.read<LocaleCubit>().changeLanguage(code);
        Navigator.pop(dialogContext);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? brandPurple.withOpacity(0.1) : brandWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? brandPurple : brandTextLight.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? brandPurple : brandTextDark,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: brandPurple),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Get user data from state
        String username = l10n.guest;
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
                          l10n.readyToPlay,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: brandTextDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.showUsPowers(username),
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
                          child: Text(
                            l10n.letsGo,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Language change button
                        TextButton.icon(
                          onPressed: _showLanguageDialog,
                          icon: Icon(Icons.language, color: brandPurple),
                          label: Text(
                            l10n.changeLanguage,
                            style: TextStyle(
                              fontSize: 16,
                              color: brandPurple,
                              fontWeight: FontWeight.w600,
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
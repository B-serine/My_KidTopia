import 'package:flutter/material.dart';
import '../assets/app_colors/app_colors.dart';
import 'package:kidtopia_app/l10n/app_localizations.dart';

class SkipToCategories extends StatelessWidget {
  const SkipToCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            l10n.skip,
            style: const TextStyle(
              color: brandPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            heroTag: 'skip_to_categories',
            mini: true,
            backgroundColor: brandWhite,
            foregroundColor: brandPurple,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/categories');
            },
            child: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}

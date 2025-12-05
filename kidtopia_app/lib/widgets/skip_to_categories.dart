import 'package:flutter/material.dart';
import '../assets/app_colors/app_colors.dart';

class SkipToCategories extends StatelessWidget {
  const SkipToCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: FloatingActionButton(
        heroTag: 'skip_to_categories',
        mini: true,
        backgroundColor: brandWhite,
        foregroundColor: brandPurple,
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/categories');
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

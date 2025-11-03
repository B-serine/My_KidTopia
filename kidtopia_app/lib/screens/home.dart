import 'package:flutter/material.dart';
import '../appColors/app_colors.dart';// import colors
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int visitCount = 0;

  @override
  Widget build(BuildContext context) {
    int score = 1250;

    return Scaffold(
      backgroundColor: brandBackground,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Removes default padding
                    foregroundColor: brandTextDark, // brandTextDark
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.account_circle, color: brandPurple, size: 28), // brandPurple
                      SizedBox(width: 8),
                      Text(
                        'Alex',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                      Icon(Icons.star, color: Colors.white, size: 24),
                      SizedBox(width: 6),
                      Text(
                        '$score',
                        style: TextStyle(
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
                    Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCOcfQVDIfG3lUAbDaxlK_sKs1rqQAqyKsoMdcJDjWBZ3ShcCPKp2VRcgBjjawcCsj5J1kCMfKpOjDT59wTJJiZrYg6uQqVIDTyizFTandytcLPKlFCrlmsTm1Gs8P1gE-blJ-J6etho7a5uY0-zkLWpNN64xYoj2jx3WFzZiLm6yH7HQBNFhXz6IUkmnQfqXXdvPabNzskQPXNhy-MFXp_1116jaZFalTroa_GB7KNjRefagkhVWgcBXEWe5WDRQubBvY7UH_aoSI',
                      width: 224,
                      height: 224,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ready to Play?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: brandTextDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Let's test your knowledge!",
                      style: TextStyle(fontSize: 18, color: brandTextLight),
                    ),
                    const SizedBox(height: 32),
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
                      onPressed: () {
                        // Navigate to quiz screen
                      },
                      child: const Text(
                        'Start Quiz',
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
  }
}

import 'package:flutter/material.dart';
// google_fonts: ^6.0.0 (in pubspec.yaml to load fonts)
import 'package:google_fonts/google_fonts.dart';
// import screens for routing
import 'screens/home.dart';
import 'screens/sign_up.dart';
import 'screens/categories.dart';
import 'screens/quiz.dart';
import 'screens/sign_in.dart';
import 'screens/score.dart';
import 'screens/profile.dart';
// import game screens
import 'screens/games/water_sort.dart';
import 'screens/games/RainbowMonsterGame.dart';
import 'screens/games/PetFeedingGame.dart';
import 'screens/games/MemoryCardGame.dart';
import 'screens/games/FoodMemoryGame.dart';
import 'screens/games/MatchingGame.dart';

void main() {
  runApp(const KidtopiaApp());
}

class KidtopiaApp extends StatelessWidget {
  const KidtopiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.comfortaaTextTheme(),
      ),
      debugShowCheckedModeBanner: false,// remove the debug banner
      title: 'Kidtopia',
      initialRoute: '/sign_up',
      routes: {
        '/': (context) => const HomeScreen(),
        '/sign_up': (context) => const SignUpScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/sign_in': (context) => const SignInScreen(),
        '/score': (context) => const ScoreScreen(),
        '/profile': (context) => const ProfileScreen(),
        // Game routes
        '/food_memory_game': (context) => const FoodMemoryGame(),
        '/matching_game': (context) => const MatchingGame(),
        '/memory_card_game': (context) => const MemoryCardGame(),
        '/pet_feeding_game': (context) => const PetFeedingGame(),
        '/rainbow_monster_game': (context) => const RainbowMonsterGame(),
        '/water_sort_game': (context) => const WaterSortGame(),
      },
    );
  }
}
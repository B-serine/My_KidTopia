import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/sign_up.dart';
import 'screens/categories.dart';
import 'screens/quiz.dart';
import 'screens/sign_in.dart';
import 'screens/score.dart';
import 'screens/profile.dart';


void main() {
  runApp(const KidtopiaApp());
}

class KidtopiaApp extends StatelessWidget {
  const KidtopiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kidtopia',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/sign_up': (context) => const SignUpScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/sign_in': (context) => const SignInScreen(),
        '/score': (context) => const ScoreScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

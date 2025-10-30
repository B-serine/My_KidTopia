import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int visitCount = 0;

  void _incrementVisit() {
    setState(() {
      visitCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kidtopia Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Visits: $visitCount'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _incrementVisit();
                Navigator.pushNamed(context, '/sign_up');
              },
              child: const Text('Go to Sign Up'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/quiz'),
              child: const Text('Play Game'),
            ),
          ],
        ),
      ),
    );
  }
}

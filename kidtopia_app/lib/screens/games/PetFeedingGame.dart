import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui';


class PetFeedingGame extends StatelessWidget {
  const PetFeedingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed the Pets',
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String currentPet = '🐶';
  int happiness = 50;
  int hunger = 50;
  String petMood = 'neutral';
  String petName = 'Buddy';
  int timeLeft = 60;
  bool gameStarted = false;
  bool gameWon = false;
  bool gameLost = false;
  Timer? gameTimer;
  
  final List<Map<String, String>> pets = [
    {'emoji': '🐶', 'name': 'Buddy', 'sound': 'Woof!'},
    {'emoji': '🐱', 'name': 'Kitty', 'sound': 'Meow!'},
    {'emoji': '🐰', 'name': 'Bunny', 'sound': 'Hop!'},
    {'emoji': '🐼', 'name': 'Panda', 'sound': 'Nom!'},
    {'emoji': '🦊', 'name': 'Foxy', 'sound': 'Yip!'},
    {'emoji': '🐻', 'name': 'Bear', 'sound': 'Roar!'},
  ];

  final List<Map<String, String>> foods = [
    {'emoji': '🍎', 'name': 'Apple', 'hunger': '5', 'happy': '5'},
    {'emoji': '🍕', 'name': 'Pizza', 'hunger': '10', 'happy': '15'},
    {'emoji': '🍦', 'name': 'Ice Cream', 'hunger': '10', 'happy': '10'},
    {'emoji': '🍖', 'name': 'Meat', 'hunger': '4', 'happy': '10'},
    {'emoji': '🥕', 'name': 'Carrot', 'hunger': '17', 'happy': '8'},
    {'emoji': '🍰', 'name': 'Cake', 'hunger': '15', 'happy': '20'},
  ];

  @override
  void initState() {
    super.initState();
    updateMood();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      gameStarted = true;
      gameWon = false;
      gameLost = false;
      happiness = 30;
      hunger = 30;
      timeLeft = 40;
      updateMood();
    });

    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
       
        hunger = max(0, hunger - 5);
        
        if (timeLeft % 2 == 0) {
          happiness = max(0, happiness - 3);
        }
        updateMood();

        // Check lose condition
        if (happiness <= 0 || hunger <= 0) {
          gameLost = true;
          gameStarted = false;
          timer.cancel();
        }

        // Check win condition - now requires 90% instead of 60%
        if (timeLeft <= 0 && happiness >= 90 && hunger >= 90) {
          gameWon = true;
          gameStarted = false;
          timer.cancel();
          showVictoryDialog();
        } else if (timeLeft <= 0) {
          gameLost = true;
          gameStarted = false;
          timer.cancel();
        }
      });
    });
  }

  void showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryDialog(
        onComplete: () {
          Navigator.of(context).pop();
          setState(() {
            gameWon = false;
            gameStarted = false;
          });
          Navigator.of(context).pushReplacementNamed('/categories'); 
        },
      ),
    );
  }




  void feedPet(Map<String, String> food) {
    if (!gameStarted) return;
    setState(() {
      hunger = min(100, hunger + int.parse(food['hunger']!));
      happiness = min(100, happiness - 10 + int.parse(food['happy']!));
      updateMood();
    });
  }

  void playWithPet() {
    if (!gameStarted) return;
    setState(() {
      happiness = min(100, happiness + 15);
      hunger = max(0, hunger - 10);
      updateMood();
    });
  }

  void petPet() {
    if (!gameStarted) return;
    setState(() {
      happiness = min(100, happiness + 10);
      updateMood();
    });
  }

  void changePet(Map<String, String> pet) {
    if (gameStarted) return;
    setState(() {
      currentPet = pet['emoji']!;
      petName = pet['name']!;
      happiness = 50;
      hunger = 50;
      updateMood();
    });
  }

  void updateMood() {
    if (happiness > 70 && hunger > 60) {
      petMood = 'happy';
    } else if (happiness < 30 || hunger < 30) {
      petMood = 'sad';
    } else {
      petMood = 'neutral';
    }
  }

  String getPetExpression() {
    if (petMood == 'happy') return '😊';
    if (petMood == 'sad') return '😢';
    return '😐';
  }

  Color getBackgroundColor() {
    if (petMood == 'happy') return Colors.green.shade100;
    if (petMood == 'sad') return Colors.red.shade100;
    return Colors.blue.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              getBackgroundColor(),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Title
                  Text(
                    '🐾 Pet Care Game 🐾',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Timer
                  if (gameStarted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '⏰ Time: ${timeLeft}s',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Pet Display
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
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
                        Text(
                          petName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              currentPet,
                              style: const TextStyle(fontSize: 120),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Text(
                                getPetExpression(),
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  '❤️ Happiness',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 120,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: happiness / 100,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '$happiness%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '🍽️ Fullness',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 120,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: hunger / 100,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '$hunger%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: gameStarted ? playWithPet : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                '⚽\nPlay',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: gameStarted ? petPet : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                '🤗\nPet',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Start/Restart Button
                  if (!gameStarted)
                    ElevatedButton(
                      onPressed: startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        gameLost ? '🔄 Try Again!' : '🎮 Start Game!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  // Game Over Message
                  if (gameLost && !gameStarted)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red, width: 3),
                      ),
                      child: Column(
                        children: const [
                          Text(
                            '😢 Oh No!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Your pet got too sad or hungry!\nTry to keep both bars above 90%!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Food Section
                  if (gameStarted)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🍴 Feed Your Pet',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: foods.map((food) {
                              return GestureDetector(
                                onTap: () => feedPet(food),
                                child: Container(
                                  width: 100,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.orange.shade200,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        food['emoji']!,
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                      Text(
                                        food['name']!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Pet Selection (only before game starts)
                  if (!gameStarted)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🐾 Choose Your Pet',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: pets.map((pet) {
                              bool isSelected = currentPet == pet['emoji'];
                              return GestureDetector(
                                onTap: () => changePet(pet),
                                child: Container(
                                  width: 100,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.purple.shade100
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.purple
                                          : Colors.grey.shade300,
                                      width: 3,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        pet['emoji']!,
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                      Text(
                                        pet['name']!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                  // Instructions
                  if (!gameStarted)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.shade200, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '📝 How to Win:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '🎯 Goal: Keep your pet happy and fed for 60 seconds!\n\n'
                            '✅ Win: Both bars stay above 90%\n'
                            '❌ Lose: Any bar reaches 0%\n\n'
                            '💡 Tips:\n'
                            '• Feed often to keep fullness up\n'
                            '• Play and pet for happiness\n'
                            '• Playing makes pet hungry!\n'
                            '• Different foods give different boosts',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Victory Dialog Widget
class VictoryDialog extends StatefulWidget {
  final VoidCallback onComplete;

  const VictoryDialog({super.key, required this.onComplete});

  @override
  State<VictoryDialog> createState() => _VictoryDialogState();
}

class _VictoryDialogState extends State<VictoryDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();

    // Auto dismiss after 5 seconds and redirect to home
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.shade400,
                  Colors.blue.shade400,
                  Colors.green.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trophy/Star Icon in the middle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade300,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 30),
                // Victory Text below the icon
                const Text(
                  'Good Job!',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  'You solved the game!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Animated stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.star,
                        size: 40,
                        color: Colors.yellow.shade300,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
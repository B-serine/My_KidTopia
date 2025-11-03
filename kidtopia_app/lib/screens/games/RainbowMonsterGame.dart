import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../../widgets/victory_dialog.dart';
import '../../widgets/game_over_dialog.dart';

class RainbowMonsterGame extends StatelessWidget {
  const RainbowMonsterGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GameScreen();
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int score = 0;
  int timeLeft = 60;
  bool gameStarted = false;
  Timer? gameTimer;
  Timer? spawnTimer;
  List<Monster> monsters = [];
  String selectedMonster = '😊';
  Color backgroundColor1 = Colors.blue.shade200;
  Color backgroundColor2 = Colors.purple.shade200;
  
  // 🎯 Win threshold - kid needs this score to win!
  final int winScoreThreshold = 250;
  
  final List<Map<String, dynamic>> monsterTypes = [
    {'emoji': '😊', 'name': 'Happy'},
    {'emoji': '⭐', 'name': 'Starry'},
    {'emoji': '💖', 'name': 'Lovely'},
    {'emoji': '😎', 'name': 'Cool'},
  ];

  final List<Map<String, dynamic>> backgrounds = [
    {'name': 'Sky', 'color1': Colors.blue.shade200, 'color2': Colors.purple.shade200},
    {'name': 'Sunset', 'color1': Colors.orange.shade200, 'color2': Colors.pink.shade300},
    {'name': 'Forest', 'color1': Colors.green.shade200, 'color2': Colors.teal.shade200},
    {'name': 'Candy', 'color1': Colors.pink.shade200, 'color2': Colors.yellow.shade200},
  ];

  @override
  void dispose() {
    gameTimer?.cancel();
    spawnTimer?.cancel();
    for (var monster in monsters) {
      monster.controller?.dispose();
    }
    super.dispose();
  }

  void startGame() {
    setState(() {
      gameStarted = true;
      score = 0;
      timeLeft = 60;
      monsters.clear();
    });

    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          endGame();
        }
      });
    });

    spawnTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      spawnMonster();
    });
  }

  void endGame() {
    gameTimer?.cancel();
    spawnTimer?.cancel();
    
    setState(() {
      gameStarted = false;
      monsters.clear();
    });

    // Check if player won or lost
    if (score >= winScoreThreshold) {
      // Player WON! 🎉
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => VictoryDialog(
          onComplete: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pushReplacementNamed('/categories'); // Go to categories
          },
        ),
      );
    } else {
      // Player LOST 😢
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => GameOverDialog(
          onPlayAgain: () {
            Navigator.of(context).pop();
            startGame();
          },
          onGoHome: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Go back to previous screen
          },
        ),
      );
    }
  }

  void spawnMonster() {
    if (!gameStarted) return;
    
    final random = Random();
    final colors = [
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.yellow.shade400,
      Colors.pink.shade400,
      Colors.purple.shade400,
      Colors.orange.shade400,
    ];

    final monster = Monster(
      id: DateTime.now().millisecondsSinceEpoch,
      x: random.nextDouble() * 0.8,
      y: 0,
      color: colors[random.nextInt(colors.length)],
      emoji: selectedMonster,
      vsync: this,
    );

    setState(() {
      monsters.add(monster);
    });

    monster.startAnimation(() {
      if (mounted) {
        setState(() {
          monsters.removeWhere((m) => m.id == monster.id);
        });
      }
    });
  }

  void catchMonster(Monster monster) {
    setState(() {
      score += 10;
      monsters.removeWhere((m) => m.id == monster.id);
    });
    monster.controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundColor1, backgroundColor2],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '🌈 Rainbow Monster Collector 🌈',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '⭐ $score',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: score >= winScoreThreshold ? Colors.green : Colors.orange,
                                ),
                              ),
                              Text(
                                '/$winScoreThreshold',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: timeLeft <= 10 ? Colors.red.shade100 : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '⏰ ${timeLeft}s',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: timeLeft <= 10 ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Settings Panel (when game not started)
              if (!gameStarted) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🎨 Customize Your Game!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Choose Monster Type:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: monsterTypes.length,
                            itemBuilder: (context, index) {
                              final type = monsterTypes[index];
                              final isSelected = selectedMonster == type['emoji'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedMonster = type['emoji']!;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [Colors.purple.shade400, Colors.pink.shade400],
                                          )
                                        : null,
                                    color: isSelected ? null : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        type['emoji']!,
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        type['name']!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Choose Background:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: backgrounds.length,
                            itemBuilder: (context, index) {
                              final bg = backgrounds[index];
                              final isSelected = backgroundColor1 == bg['color1'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    backgroundColor1 = bg['color1']!;
                                    backgroundColor2 = bg['color2']!;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [bg['color1']!, bg['color2']!],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: isSelected
                                        ? Border.all(color: Colors.purple, width: 3)
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      bg['name']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: ElevatedButton(
                              onPressed: startGame,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: Colors.green,
                              ),
                              child: const Text(
                                '🎮 Start Game!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Game Area
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      children: [
                        ...monsters.map((monster) {
                          return AnimatedBuilder(
                            animation: monster.controller!,
                            builder: (context, child) {
                              return Positioned(
                                left: MediaQuery.of(context).size.width * monster.x,
                                top: MediaQuery.of(context).size.height * monster.y * 0.5,
                                child: GestureDetector(
                                  onTap: () => catchMonster(monster),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: monster.color,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        monster.emoji,
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],

              // Instructions
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 How to Play:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🎯 Goal: Score $winScoreThreshold points to win!\n👆 Tap bouncing monsters to catch them (10 points each).\n⏰ You have 60 seconds. Good luck! 🎈',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Monster {
  final int id;
  double x;
  double y;
  final Color color;
  final String emoji;
  AnimationController? controller;
  double speedY = 0.02;
  double gravity = 0.001;

  Monster({
    required this.id,
    required this.x,
    required this.y,
    required this.color,
    required this.emoji,
    required TickerProvider vsync,
  }) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 10),
    );
  }

  void startAnimation(VoidCallback onComplete) {
    controller?.addListener(() {
      y += speedY;
      speedY += gravity;
      
      if (y >= 1.0) {
        y = 1.0;
        speedY = -speedY * 0.7;
      }
      
      if (controller!.value >= 0.95) {
        controller?.stop();
        onComplete();
      }
    });
    controller?.forward();
  }
}
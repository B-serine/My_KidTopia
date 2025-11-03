import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import '../../widgets/victory_dialog.dart';
import '../../widgets/game_over_dialog.dart';


class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> with TickerProviderStateMixin {
  int level = 1;
  int timeLeft = 60;
  Timer? gameTimer;
  List<GameItem> items = [];
  List<Basket> baskets = [];
  bool isGameOver = false;
  bool isVictory = false;
  late AnimationController _celebrationController;
  
  // Static data - 7 levels with increasing difficulty
  final List<Map<String, dynamic>> staticLevels = [
    {
      'time': 60,
      'items': [
        {'emoji': '🍎', 'type': 'apple'},
        {'emoji': '🍎', 'type': 'apple'},
        {'emoji': '🍌', 'type': 'banana'},
        {'emoji': '🍌', 'type': 'banana'},
        {'emoji': '🍊', 'type': 'orange'},
        {'emoji': '🍊', 'type': 'orange'},
      ],
      'baskets': [
        {'emoji': '🧺', 'type': 'apple', 'label': '🍎'},
        {'emoji': '🧺', 'type': 'banana', 'label': '🍌'},
        {'emoji': '🧺', 'type': 'orange', 'label': '🍊'},
      ]
    },
    {
      'time': 55,
      'items': [
        {'emoji': '🍇', 'type': 'grape'},
        {'emoji': '🍇', 'type': 'grape'},
        {'emoji': '🍓', 'type': 'strawberry'},
        {'emoji': '🍓', 'type': 'strawberry'},
        {'emoji': '🍉', 'type': 'watermelon'},
        {'emoji': '🍉', 'type': 'watermelon'},
        {'emoji': '🍒', 'type': 'cherry'},
        {'emoji': '🍒', 'type': 'cherry'},
      ],
      'baskets': [
        {'emoji': '🧺', 'type': 'grape', 'label': '🍇'},
        {'emoji': '🧺', 'type': 'strawberry', 'label': '🍓'},
        {'emoji': '🧺', 'type': 'watermelon', 'label': '🍉'},
        {'emoji': '🧺', 'type': 'cherry', 'label': '🍒'},
      ]
    },
    {
      'time': 50,
      'items': [
        {'emoji': '🥕', 'type': 'carrot'},
        {'emoji': '🥕', 'type': 'carrot'},
        {'emoji': '🥦', 'type': 'broccoli'},
        {'emoji': '🥦', 'type': 'broccoli'},
        {'emoji': '🌽', 'type': 'corn'},
        {'emoji': '🌽', 'type': 'corn'},
        {'emoji': '🍅', 'type': 'tomato'},
        {'emoji': '🍅', 'type': 'tomato'},
        {'emoji': '🥒', 'type': 'cucumber'},
        {'emoji': '🥒', 'type': 'cucumber'},
      ],
      'baskets': [
        {'emoji': '🧺', 'type': 'carrot', 'label': '🥕'},
        {'emoji': '🧺', 'type': 'broccoli', 'label': '🥦'},
        {'emoji': '🧺', 'type': 'corn', 'label': '🌽'},
        {'emoji': '🧺', 'type': 'tomato', 'label': '🍅'},
        {'emoji': '🧺', 'type': 'cucumber', 'label': '🥒'},
      ]
    },
    {
      'time': 45,
      'items': [
        {'emoji': '🐶', 'type': 'dog'},
        {'emoji': '🐶', 'type': 'dog'},
        {'emoji': '🐱', 'type': 'cat'},
        {'emoji': '🐱', 'type': 'cat'},
        {'emoji': '🐰', 'type': 'rabbit'},
        {'emoji': '🐰', 'type': 'rabbit'},
        {'emoji': '🐻', 'type': 'bear'},
        {'emoji': '🐻', 'type': 'bear'},
        {'emoji': '🐼', 'type': 'panda'},
        {'emoji': '🐼', 'type': 'panda'},
        {'emoji': '🦁', 'type': 'lion'},
        {'emoji': '🦁', 'type': 'lion'},
      ],
      'baskets': [
        {'emoji': '🏠', 'type': 'dog', 'label': '🐶'},
        {'emoji': '🏠', 'type': 'cat', 'label': '🐱'},
        {'emoji': '🏠', 'type': 'rabbit', 'label': '🐰'},
        {'emoji': '🏠', 'type': 'bear', 'label': '🐻'},
        {'emoji': '🏠', 'type': 'panda', 'label': '🐼'},
        {'emoji': '🏠', 'type': 'lion', 'label': '🦁'},
      ]
    },
    {
      'time': 40,
      'items': [
        {'emoji': '⚽', 'type': 'soccer'},
        {'emoji': '⚽', 'type': 'soccer'},
        {'emoji': '🏀', 'type': 'basketball'},
        {'emoji': '🏀', 'type': 'basketball'},
        {'emoji': '🎾', 'type': 'tennis'},
        {'emoji': '🎾', 'type': 'tennis'},
        {'emoji': '🏈', 'type': 'football'},
        {'emoji': '🏈', 'type': 'football'},
        {'emoji': '⚾', 'type': 'baseball'},
        {'emoji': '⚾', 'type': 'baseball'},
        {'emoji': '🎱', 'type': 'billiard'},
        {'emoji': '🎱', 'type': 'billiard'},
        {'emoji': '🏐', 'type': 'volleyball'},
        {'emoji': '🏐', 'type': 'volleyball'},
      ],
      'baskets': [
        {'emoji': '🎯', 'type': 'soccer', 'label': '⚽'},
        {'emoji': '🎯', 'type': 'basketball', 'label': '🏀'},
        {'emoji': '🎯', 'type': 'tennis', 'label': '🎾'},
        {'emoji': '🎯', 'type': 'football', 'label': '🏈'},
        {'emoji': '🎯', 'type': 'baseball', 'label': '⚾'},
        {'emoji': '🎯', 'type': 'billiard', 'label': '🎱'},
        {'emoji': '🎯', 'type': 'volleyball', 'label': '🏐'},
      ]
    },
    {
      'time': 37,
      'items': [
        {'emoji': '🐞', 'type': 'ladybug'},
        {'emoji': '🐞', 'type': 'ladybug'},
        {'emoji': '🕷️', 'type': 'spider'},
        {'emoji': '🕷️', 'type': 'spider'},
        {'emoji': '🦋', 'type': 'butterfly'},
        {'emoji': '🦋', 'type': 'butterfly'},
        {'emoji': '🦗', 'type': 'cricket'},
        {'emoji': '🦗', 'type': 'cricket'},
        {'emoji': '🐌', 'type': 'snail'},
        {'emoji': '🐌', 'type': 'snail'},
        {'emoji': '🐝', 'type': 'bee'},
        {'emoji': '🐝', 'type': 'bee'},
        {'emoji': '🪰', 'type': 'fly'},
        {'emoji': '🪰', 'type': 'fly'},
      ],
      'baskets': [
        {'emoji': '🖼️', 'type': 'ladybug', 'label': '🐞'},
        {'emoji': '🖼️', 'type': 'spider', 'label': '🕷️'},
        {'emoji': '🖼️', 'type': 'butterfly', 'label': '🦋'},
        {'emoji': '🖼️', 'type': 'cricket', 'label': '🦗'},
        {'emoji': '🖼️', 'type': 'snail', 'label': '🐌'},
        {'emoji': '🖼️', 'type': 'bee', 'label': '🐝'},
        {'emoji': '🖼️', 'type': 'fly', 'label': '🪰'},
      ]
    },
    {
      'time': 35,
      'items': [
        {'emoji': '🌸', 'type': 'cherry_blossom'},
        {'emoji': '🌸', 'type': 'cherry_blossom'},
        {'emoji': '🌺', 'type': 'hibiscus'},
        {'emoji': '🌺', 'type': 'hibiscus'},
        {'emoji': '🌻', 'type': 'sunflower'},
        {'emoji': '🌻', 'type': 'sunflower'},
        {'emoji': '🌷', 'type': 'tulip'},
        {'emoji': '🌷', 'type': 'tulip'},
        {'emoji': '🌹', 'type': 'rose'},
        {'emoji': '🌹', 'type': 'rose'},
        {'emoji': '🍀', 'type': 'green_leaf'},
        {'emoji': '🍀', 'type': 'green_leaf'},
        {'emoji': '🍁', 'type': 'red_leaf'},
        {'emoji': '🍁', 'type': 'red_leaf'},
      ],
      'baskets': [
        {'emoji': '🏺', 'type': 'cherry_blossom', 'label': '🌸'},
        {'emoji': '🏺', 'type': 'hibiscus', 'label': '🌺'},
        {'emoji': '🏺', 'type': 'sunflower', 'label': '🌻'},
        {'emoji': '🏺', 'type': 'tulip', 'label': '🌷'},
        {'emoji': '🏺', 'type': 'rose', 'label': '🌹'},
        {'emoji': '🏺', 'type': 'green_leaf', 'label': '🍀'},
        {'emoji': '🏺', 'type': 'red_leaf', 'label': '🍁'},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
    _loadLevel();
  }

  void _loadLevel() {
    gameTimer?.cancel();
    if (level > staticLevels.length) {
      _showVictory();
      return;
    }

    final levelData = staticLevels[level - 1];
    setState(() {
      timeLeft = levelData['time'];
      items.clear();
      baskets.clear();
      isGameOver = false;

      // Load baskets
      final basketList = levelData['baskets'] as List;
      for (var i = 0; i < basketList.length; i++) {
        baskets.add(Basket(
          emoji: basketList[i]['emoji'],
          type: basketList[i]['type'],
          label: basketList[i]['label'],
          index: i,
        ));
      }

      // Load items (shuffled)
      final itemList = (levelData['items'] as List).toList();
      itemList.shuffle();
      for (var i = 0; i < itemList.length; i++) {
        items.add(GameItem(
          emoji: itemList[i]['emoji'],
          type: itemList[i]['type'],
          index: i,
        ));
      }
    });

    _startTimer();
  }

  void _startTimer() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timer.cancel();
          _checkLevelCompletion();
        }
      });
    });
  }

  void _checkMatch(GameItem item, Basket basket) {
    if (item.type == basket.type) {
      setState(() {
        item.isMatched = true;
        basket.count++;
      });

      // Check if all items matched
      if (items.every((item) => item.isMatched)) {
        gameTimer?.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          _checkLevelCompletion();
        });
      }
    }
  }

  void _checkLevelCompletion() {
    // Check if all items are correctly matched
    bool allMatched = items.every((item) => item.isMatched);
    
    if (allMatched) {
      // Win condition - all items in correct baskets
      if (level < staticLevels.length) {
        _showLevelComplete();
      } else {
        _showVictory();
      }
    } else {
      // Lose condition - time's up or not all items matched
      _showGameOver();
    }
  }

  void _showLevelComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.blue.shade400],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              const Text(
                'Level Complete!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    level++;
                    _loadLevel();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Next Level! 🚀',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVictory() {
    setState(() => isVictory = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryDialog(
        onComplete: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Go back to previous screen
          // Navigate to categories page after 5 seconds
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.pushNamed(context, '/categories');
          });
        },
      ),
    );
  }

  void _showGameOver() {
    setState(() => isGameOver = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        onPlayAgain: () {
          Navigator.of(context).pop();
          setState(() {
            level = 1;
            _loadLevel();
          });
        },
        onGoHome: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade100, Colors.purple.shade100, Colors.blue.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildGameArea()),
              _buildBaskets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Row(
              children: [
                const Text('⏱️', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  '$timeLeft',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: timeLeft <= 10 ? Colors.red : Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Text(
              'Level $level',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          if (item.isMatched) return const SizedBox.shrink();
          
          return Draggable<GameItem>(
            data: item,
            feedback: Material(
              color: Colors.transparent,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
                ),
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 50)),
                ),
              ),
            ),
            childWhenDragging: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple.shade200, width: 3),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Center(
                child: Text(item.emoji, style: const TextStyle(fontSize: 60)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBaskets() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: false,
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          physics: const BouncingScrollPhysics(),
          itemCount: baskets.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final basket = baskets[index];
            return MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: DragTarget<GameItem>(
                onAcceptWithDetails: (details) => _checkMatch(details.data, basket),
                builder: (context, candidateData, rejectedData) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: candidateData.isNotEmpty
                            ? [Colors.green.shade300, Colors.green.shade500]
                            : [Colors.orange.shade300, Colors.orange.shade500],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: candidateData.isNotEmpty ? Colors.green : Colors.orange,
                          blurRadius: candidateData.isNotEmpty ? 20 : 8,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                basket.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                basket.label,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        if (basket.count > 0)
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${basket.count}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class GameItem {
  final String emoji;
  final String type;
  final int index;
  bool isMatched;

  GameItem({
    required this.emoji,
    required this.type,
    required this.index,
    this.isMatched = false,
  });
}

class Basket {
  final String emoji;
  final String type;
  final String label;
  final int index;
  int count;

  Basket({
    required this.emoji,
    required this.type,
    required this.label,
    required this.index,
    this.count = 0,
  });
}
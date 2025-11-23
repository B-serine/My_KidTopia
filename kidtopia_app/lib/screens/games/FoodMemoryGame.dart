
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../widgets/victory_dialog2.dart';

class FoodMemoryGame extends StatefulWidget {
  const FoodMemoryGame({super.key});

  @override
  State<FoodMemoryGame> createState() => _FoodMemoryGameState();
}

class FoodCardItem {
  final String emoji;
  final int id;
  bool isFlipped;
  bool isMatched;

  FoodCardItem({
    required this.emoji,
    required this.id,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class _FoodMemoryGameState extends State<FoodMemoryGame> {
  List<FoodCardItem> cards = [];
  List<int> flippedIndices = [];
  bool canFlip = true;
  int matchedPairs = 0;
  bool gameStarted = false;

  final List<String> foods = [
    '🍎', '🍕', '🍔', '🍟', '🍿', '🥤',
    '🍩', '🍪', '🍰', '🧁', '🍦', '🍨',
    '🍇', '🍓', '🍒', '🌮', '🥝', '🍌',
  ];

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeGame() {
    cards.clear();
    matchedPairs = 0;
    flippedIndices.clear();
    gameStarted = true;

    // Create pairs of cards (18 pairs = 36 cards for 6x6 grid)
    for (int i = 0; i < foods.length; i++) {
      cards.add(FoodCardItem(emoji: foods[i], id: i));
      cards.add(FoodCardItem(emoji: foods[i], id: i));
    }

    // Shuffle cards
    cards.shuffle(Random());

    setState(() {});
  }

  void flipCard(int index) {
    if (!canFlip || !gameStarted) return;
    if (cards[index].isFlipped || cards[index].isMatched) return;
    if (flippedIndices.length >= 2) return;

    setState(() {
      cards[index].isFlipped = true;
      flippedIndices.add(index);
    });

    if (flippedIndices.length == 2) {
      canFlip = false;
      checkMatch();
    }
  }

  void checkMatch() {
    int first = flippedIndices[0];
    int second = flippedIndices[1];

    if (cards[first].id == cards[second].id) {
      // Match found!
      setState(() {
        cards[first].isMatched = true;
        cards[second].isMatched = true;
        matchedPairs++;
      });

      flippedIndices.clear();
      canFlip = true;

      // Check if all pairs are matched
      if (matchedPairs == 18) {
        gameStarted = false;
        Future.delayed(const Duration(milliseconds: 500), () {
          showVictoryDialogScreen();
        });
      }
    } else {
      // No match, flip back after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          cards[first].isFlipped = false;
          cards[second].isFlipped = false;
          flippedIndices.clear();
          canFlip = true;
        });
      });
    }
  }

  void showVictoryDialogScreen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryDialog(
        onComplete: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pushReplacementNamed('/categories'); // Go to /categories
        },
      ),
    );
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
              
              Colors.pink.shade200,
              const Color.fromARGB(255, 252, 213, 243),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    // Title
                    const Text(
                      '🍕 Food Memory',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    // Matched pairs
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '✨ $matchedPairs/18',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Game Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return FoodMemoryCard(
                        card: cards[index],
                        onTap: () => flipCard(index),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Food Memory Card Widget
class FoodMemoryCard extends StatelessWidget {
  final FoodCardItem card;
  final VoidCallback onTap;

  const FoodMemoryCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: card.isMatched
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lime.shade300,
                    Colors.green.shade400,
                  ],
                )
              : card.isFlipped
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.orange.shade50,
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepOrange.shade400,
                        Colors.red.shade400,
                      ],
                    ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: card.isMatched 
                ? Colors.lime 
                : card.isFlipped 
                    ? Colors.orange.shade300
                    : Colors.red.shade600,
            width: 3,
          ),
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Text(
                  card.emoji,
                  style: const TextStyle(fontSize: 32),
                )
              : const Text(
                  '🍽️',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
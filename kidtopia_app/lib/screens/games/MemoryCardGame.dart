import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../widgets/victory_dialog2.dart';
import '../../widgets/game_over_dialog.dart';
import '../../l10n/app_localizations.dart';

class MemoryCardGame extends StatefulWidget {
  const MemoryCardGame({super.key});

  @override
  State<MemoryCardGame> createState() => _MemoryCardGameState();
}

class CardItem {
  final String emoji;
  final int id;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.emoji,
    required this.id,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class _MemoryCardGameState extends State<MemoryCardGame> {
  List<CardItem> cards = [];
  List<int> flippedIndices = [];
  bool canFlip = true;
  int matchedPairs = 0;
  bool gameStarted = false;

  final List<String> animals = [
    '🐶',
    '🐱',
    '🐭',
    '🐹',
    '🐰',
    '🦊',
    '🐻',
    '🐼',
    '🐨',
    '🐯',
    '🦁',
    '🐮',
    '🐷',
    '🐸',
    '🐵',
    '🐔',
    '🐧',
    '🦆',
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

    for (int i = 0; i < animals.length; i++) {
      cards.add(CardItem(emoji: animals[i], id: i));
      cards.add(CardItem(emoji: animals[i], id: i));
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
          Navigator.of(
            context,
          ).pushReplacementNamed('/categories'); // Go to /categories
        },
      ),
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        onPlayAgain: () {
          Navigator.of(context).pop();
          initializeGame();
        },
        onGoHome: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pushReplacementNamed('/'); // Go to home
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade200, Colors.purple.shade100],
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
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/'),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        // Title
                        Text(
                          '🎮 ${l10n.memoryGame}',
                          style: const TextStyle(
                            fontSize: 23,
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
                            color: Colors.green,
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
                              fontSize: 10,
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          return MemoryCard(
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
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'skip_to_categories',
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/categories');
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}

// Memory Card Widget
class MemoryCard extends StatelessWidget {
  final CardItem card;
  final VoidCallback onTap;

  const MemoryCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isMatched
              ? Colors.green.shade200
              : card.isFlipped
              ? Colors.white
              : Colors.purple.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: card.isMatched ? Colors.green : Colors.white,
            width: 2,
          ),
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Text(card.emoji, style: const TextStyle(fontSize: 32))
              : const Text(
                  '?',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

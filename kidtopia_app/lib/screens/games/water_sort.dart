import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../../widgets/victory_dialog.dart';

class WaterSortGame extends StatefulWidget {
  const WaterSortGame({Key? key}) : super(key: key);

  @override
  State<WaterSortGame> createState() => _WaterSortGameState();
}

class _WaterSortGameState extends State<WaterSortGame> {
  List<List<Color>> bottles = [];
  int? selectedBottle;
  final int bottleCapacity = 4;
  Timer? victoryTimer;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  @override
  void dispose() {
    victoryTimer?.cancel();
    super.dispose();
  }

  void initializeGame() {
    // Cancel any pending victory dialog
    victoryTimer?.cancel();
    
    // All available colors (7 colors)
    List<Color> allAvailableColors = [
      const Color.fromARGB(255, 165, 64, 183),
      const Color.fromARGB(255, 248, 88, 141),
      const Color.fromARGB(255, 37, 157, 255),
      const Color.fromARGB(255, 63, 234, 69),
      const Color.fromRGBO(252, 255, 59, 1),
      const Color.fromARGB(255, 247, 47, 33),
      const Color.fromARGB(255, 255, 160, 17),
    ];

    // Randomly select 4 colors from the 7 available
    allAvailableColors.shuffle(Random());
    List<Color> selectedColors = allAvailableColors.take(4).toList();

    // Create a list of all color units (4 units per color)
    List<Color> allColors = [];
    for (var color in selectedColors) {
      for (int i = 0; i < bottleCapacity; i++) {
        allColors.add(color);
      }
    }

    // Shuffle the color units
    allColors.shuffle(Random());

    // Distribute into 4 bottles (filled) + 2 empty bottles = 6 total
    bottles = [];
    for (int i = 0; i < 4; i++) {
      bottles.add([
        allColors[i * 4],
        allColors[i * 4 + 1],
        allColors[i * 4 + 2],
        allColors[i * 4 + 3],
      ]);
    }

    // Add 2 empty bottles
    bottles.add([]);
    bottles.add([]);

    setState(() {
      selectedBottle = null;
    });
  }

  void onBottleTap(int index) {
    setState(() {
      if (selectedBottle == null) {
        // Select this bottle if it's not empty
        if (bottles[index].isNotEmpty) {
          selectedBottle = index;
        }
      } else {
        // Try to pour into this bottle
        if (selectedBottle != index && canPour(selectedBottle!, index)) {
          pourWater(selectedBottle!, index);
          selectedBottle = null;
          
          // Check if game is won
          if (checkWin()) {
            victoryTimer = Timer(const Duration(seconds: 5), () {
              if (mounted) {
                showVictoryDialog();
              }
            });
          }
        } else {
          // Deselect or select new bottle
          if (bottles[index].isNotEmpty) {
            selectedBottle = index;
          } else {
            selectedBottle = null;
          }
        }
      }
    });
  }

  bool canPour(int from, int to) {
    if (bottles[from].isEmpty) return false;
    if (bottles[to].length >= bottleCapacity) return false;
    
    if (bottles[to].isEmpty) return true;
    
    // Can only pour if top colors match
    Color fromColor = bottles[from].last;
    Color toColor = bottles[to].last;
    return fromColor == toColor;
  }

  void pourWater(int from, int to) {
    // Pour only ONE water unit at a time
    if (bottles[from].isNotEmpty && bottles[to].length < bottleCapacity) {
      bottles[to].add(bottles[from].removeLast());
    }
  }

  bool checkWin() {
    for (var bottle in bottles) {
      if (bottle.isEmpty) continue;
      if (bottle.length != bottleCapacity) return false;
      
      // Check if all colors in bottle are same
      Color firstColor = bottle[0];
      for (var color in bottle) {
        if (color != firstColor) return false;
      }
    }
    return true;
  }

  void showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryDialog(
        onComplete: () {
          // Close dialog and navigate back to home
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pushReplacementNamed('/categories'); // Go to /categories
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Sort Game'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, // White background
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Cute message above bottles
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pink.shade200, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop, color: Colors.blue.shade400, size: 24),
                  const SizedBox(width: 10),
                  const Flexible(
                    child: Text(
                      'Don\'t let them stay empty! 💧',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.water_drop, color: Colors.pink.shade400, size: 24),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Game bottles
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(bottles.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () => onBottleTap(index),
                        child: BottleWidget(
                          colors: bottles[index],
                          isSelected: selectedBottle == index,
                          capacity: bottleCapacity,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            // Restart button in the middle
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: initializeGame,
                icon: const Icon(Icons.refresh, size: 26),
                label: const Text(
                  'Play Again',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottleWidget extends StatelessWidget {
  final List<Color> colors;
  final bool isSelected;
  final int capacity;

  const BottleWidget({
    Key? key,
    required this.colors,
    required this.isSelected,
    required this.capacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.orange : Colors.transparent,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bottle
          Container(
            width: 55,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade700, width: 2.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...List.generate(capacity, (index) {
                  int colorIndex = capacity - 1 - index;
                  bool hasColor = colorIndex < colors.length;
                  
                  return Container(
                    width: 50,
                    height: 38,
                    decoration: BoxDecoration(
                      color: hasColor ? colors[colorIndex] : Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          // Bottle base
          Container(
            width: 48,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
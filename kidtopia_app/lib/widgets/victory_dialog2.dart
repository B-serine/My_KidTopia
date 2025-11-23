import 'package:flutter/material.dart';
import 'dart:ui';


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
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

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
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink.shade400,
                  Colors.purple.shade400,
                  Colors.blue.shade400,
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
                // Rotating Trophy
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade300,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.6),
                          blurRadius: 25,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Victory Text
                const Text(
                  '🎉 YOU WIN! 🎉',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(3, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Amazing Memory!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.star,
                        size: 35,
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

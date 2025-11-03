import 'package:flutter/material.dart';
import '../assets/app_colors/app_colors.dart';

class CategoriesScreen extends StatefulWidget {
  final int totalScore;
  final bool isPremium; // Add premium status

  const CategoriesScreen({
    Key? key,
    this.totalScore = 1250,
    this.isPremium = false, // Default to non-premium
  }) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesScreen> {
  int _selectedIndex = 1;
  String _selectedCategory = '';

  // Define unlock requirements for score-locked categories
  final Map<String, int> _scoreRequirements = {
    'Colors': 500,
    'Body Parts': 800,
    'Emotions': 1200,
    'Tools': 1500,
  };

  void _onCategoryTap(String category, CategoryLockType lockType) {
    // For demo purposes - all categories open normally
    // Just show the lock dialogs for visual demonstration
    if (lockType == CategoryLockType.premium) {
      _showPremiumDialog();
      return;
    }

    if (lockType == CategoryLockType.score) {
      final requiredScore = _scoreRequirements[category] ?? 0;
      _showScoreRequiredDialog(category, requiredScore);
      return;
    }

    // Category is unlocked - just show snackbar for demo
    setState(() {
      _selectedCategory = category;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $category category... (Demo only)'),
        duration: const Duration(seconds: 1),
        backgroundColor: brandPurple,
      ),
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.workspace_premium, color: brandYellow, size: 28),
              const SizedBox(width: 8),
              const Text('Premium Required'),
            ],
          ),
          content: const Text(
            'Unlock this category and many more features with Premium subscription!',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Maybe Later',
                style: TextStyle(color: brandTextLight),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to premium subscription page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Opening Premium subscription...'),
                    backgroundColor: brandYellow,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Get Premium', style: TextStyle(color: brandWhite)),
            ),
          ],
        );
      },
    );
  }

  void _showScoreRequiredDialog(String category, int requiredScore) {
    final pointsNeeded = requiredScore - widget.totalScore;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.lock, color: brandPurple, size: 28),
              const SizedBox(width: 8),
              const Text('Score Required'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You need $requiredScore points to unlock $category!',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'Earn $pointsNeeded more points by completing other categories.',
                style: TextStyle(fontSize: 14, color: brandTextLight),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Could navigate back or to unlocked categories
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Keep Playing', style: TextStyle(color: brandWhite)),
            ),
          ],
        );
      },
    );
  }

  CategoryLockType _getCategoryLockType(String category) {
    // First 2 categories are always unlocked
    if (category == 'Animals' || category == 'Fruits') {
      return CategoryLockType.unlocked;
    }

    // Last 4 categories require premium
    if (category == 'Emotions' ||
        category == 'Tools' ||
        category == 'Sports' ||
        category == 'Math') {
      return widget.isPremium
          ? CategoryLockType.unlocked
          : CategoryLockType.premium;
    }

    // Middle 4 categories require score
    if (_scoreRequirements.containsKey(category)) {
      final requiredScore = _scoreRequirements[category]!;
      return widget.totalScore >= requiredScore
          ? CategoryLockType.unlocked
          : CategoryLockType.score;
    }

    return CategoryLockType.unlocked;
  }

  void _onBottomNavTap(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Use pushReplacementNamed so the bottom-nav behaves like a top-level tab switch
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/');
      return;
    }

    if (index == 1) {
      // Already on categories, nothing to do
      return;
    }

    if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: brandTextDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                color: brandTextDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: brandYellow,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: brandYellow.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.stars_rounded, color: brandWhite, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.totalScore}',
                    style: TextStyle(
                      color: brandWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
            children: [
              CategoryCard(
                title: 'Animals',
                image: 'assets/animals.jpg',
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4A574), Color(0xFF8B6F47)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.pets,
                isSelected: _selectedCategory == 'Animals',
                lockType: _getCategoryLockType('Animals'),
                onTap: () {
                  final lock = _getCategoryLockType('Animals');
                  if (lock == CategoryLockType.unlocked) {
                    Navigator.pushNamed(context, '/quiz');
                  } else {
                    _onCategoryTap('Animals', lock);
                  }
                },
              ),
              CategoryCard(
                title: 'Fruits',
                image: 'assets/fruits.jpg',
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8D5C4), Color(0xFFD4C5B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.apple,
                isSelected: _selectedCategory == 'Fruits',
                lockType: _getCategoryLockType('Fruits'),
                onTap: () =>
                    _onCategoryTap('Fruits', _getCategoryLockType('Fruits')),
              ),
              CategoryCard(
                title: 'Vegetables',
                image: 'assets/vegetables.jpg',
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4C5B0), Color(0xFFBFAC95)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.eco,
                isSelected: _selectedCategory == 'Vegetables',
                lockType: _getCategoryLockType('Vegetables'),
                requiredScore: _scoreRequirements['Vegetables'],
                onTap: () => _onCategoryTap(
                  'Vegetables',
                  _getCategoryLockType('Vegetables'),
                ),
              ),
              CategoryCard(
                title: 'Transportation',
                image: 'assets/transportation.jpg',
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.directions_car,
                isSelected: _selectedCategory == 'Transportation',
                lockType: _getCategoryLockType('Transportation'),
                requiredScore: _scoreRequirements['Transportation'],
                onTap: () => _onCategoryTap(
                  'Transportation',
                  _getCategoryLockType('Transportation'),
                ),
              ),
              CategoryCard(
                title: 'Colors',
                image: 'assets/colors.png',
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE94B91),
                    Color(0xFFFF6B6B),
                    Color(0xFFFFAA00),
                    Color(0xFFFFF176),
                    Color(0xFF4ECDC4),
                    Color(0xFF5D9CEC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.palette,
                isSelected: _selectedCategory == 'Colors',
                lockType: _getCategoryLockType('Colors'),
                requiredScore: _scoreRequirements['Colors'],
                onTap: () =>
                    _onCategoryTap('Colors', _getCategoryLockType('Colors')),
              ),
              CategoryCard(
                title: 'Body Parts',
                image: 'assets/body_parts.png',
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8CDB5), Color(0xFFD4B5A0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.back_hand,
                isSelected: _selectedCategory == 'Body Parts',
                lockType: _getCategoryLockType('Body Parts'),
                requiredScore: _scoreRequirements['Body Parts'],
                onTap: () => _onCategoryTap(
                  'Body Parts',
                  _getCategoryLockType('Body Parts'),
                ),
              ),
              CategoryCard(
                title: 'Emotions',
                image: 'assets/emotions.png',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE082), Color(0xFFD4A574)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.emoji_emotions,
                isSelected: _selectedCategory == 'Emotions',
                lockType: _getCategoryLockType('Emotions'),
                onTap: () => _onCategoryTap(
                  'Emotions',
                  _getCategoryLockType('Emotions'),
                ),
              ),
              CategoryCard(
                title: 'Tools',
                image: 'assets/tools.png',
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.build,
                isSelected: _selectedCategory == 'Tools',
                lockType: _getCategoryLockType('Tools'),
                onTap: () =>
                    _onCategoryTap('Tools', _getCategoryLockType('Tools')),
              ),
              CategoryCard(
                title: 'Sports',
                image: 'assets/sports.png',
                gradient: const LinearGradient(
                  colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.sports_soccer,
                isSelected: _selectedCategory == 'Sports',
                lockType: _getCategoryLockType('Sports'),
                onTap: () =>
                    _onCategoryTap('Sports', _getCategoryLockType('Sports')),
              ),
              CategoryCard(
                title: 'Math',
                image: 'assets/math.png',
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.calculate,
                isSelected: _selectedCategory == 'Math',
                lockType: _getCategoryLockType('Math'),
                onTap: () =>
                    _onCategoryTap('Math', _getCategoryLockType('Math')),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: brandWhite,
        selectedItemColor: brandPurple,
        unselectedItemColor: brandTextLight,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

enum CategoryLockType { unlocked, score, premium }

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final Gradient gradient;
  final IconData icon;
  final bool isSelected;
  final CategoryLockType lockType;
  final int? requiredScore;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.image,
    required this.gradient,
    required this.icon,
    this.isSelected = false,
    this.lockType = CategoryLockType.unlocked,
    this.requiredScore,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 48) / 2;
    final isLocked = lockType != CategoryLockType.unlocked;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.2 : 0.1),
              blurRadius: isSelected ? 15 : 10,
              offset: const Offset(0, 4),
            ),
            if (isSelected)
              BoxShadow(
                color: brandPurple.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
          border: isSelected ? Border.all(color: brandPurple, width: 3) : null,
        ),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: cardSize * 0.6,
                          color: brandWhite.withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(isLocked ? 0.5 : 0.3),
                    Colors.black.withOpacity(isLocked ? 0.7 : 0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: isLocked ? brandWhite.withOpacity(0.6) : brandWhite,
                    size: cardSize * 0.2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: brandWhite,
                          fontSize: cardSize * 0.12,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      if (lockType == CategoryLockType.score &&
                          requiredScore != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '$requiredScore pts',
                            style: TextStyle(
                              color: brandYellow,
                              fontSize: cardSize * 0.08,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Lock overlay
            if (isLocked)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    lockType == CategoryLockType.premium
                        ? Icons.workspace_premium
                        : Icons.lock,
                    color: lockType == CategoryLockType.premium
                        ? brandYellow
                        : brandWhite,
                    size: cardSize * 0.25,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

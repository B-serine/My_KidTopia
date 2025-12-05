import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../assets/app_colors/app_colors.dart';
import '../logic/cubits/auth_cubit.dart';
import '../logic/cubits/category_cubit.dart';
import '../logic/cubits/quiz_cubit.dart';
import '../data/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesScreen> {
  int _selectedIndex = 1;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Fetch categories from database
    context.read<CategoryCubit>().loadCategories();
  }

  // Parse hex color from database
  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return brandPurple;
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return brandPurple;
    }
  }

  // Get icon based on category name
  IconData _getCategoryIcon(String name) {
    final iconMap = {
      'animals': Icons.pets,
      'fruits': Icons.apple,
      'vegetables': Icons.eco,
      'transportation': Icons.directions_car,
      'colors': Icons.palette,
      'body parts': Icons.accessibility_new,
      'emotions': Icons.emoji_emotions,
      'tools': Icons.build,
      'sports': Icons.sports_soccer,
      'music': Icons.music_note,
      'science': Icons.science,
      'nature': Icons.nature,
      'food': Icons.fastfood,
      'numbers': Icons.looks_one,
      'letters': Icons.abc,
    };
    return iconMap[name.toLowerCase()] ?? Icons.category;
  }

  void _onCategoryTap(Category category, int userScore, bool isPremium) {
    // Check if category is locked by premium
    if (category.isPremium && !isPremium) {
      _showPremiumDialog();
      return;
    }
    
    // Check if category is locked by score
    if (category.requiredScore > userScore && !isPremium) {
      _showScoreRequiredDialog(category.name, category.requiredScore, userScore);
      return;
    }

    setState(() => _selectedCategoryId = category.id);

    // Load quiz from database
    context.read<QuizCubit>().loadQuiz(category.id!);
    Navigator.pushNamed(context, '/quiz');
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.workspace_premium, color: brandYellow, size: 28),
          const SizedBox(width: 8),
          const Text('Premium Required'),
        ]),
        content: const Text('Unlock this category with Premium subscription!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe Later', style: TextStyle(color: brandTextLight)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().upgradeToPremium();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: brandYellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Get Premium', style: TextStyle(color: brandWhite)),
          ),
        ],
      ),
    );
  }

  void _showScoreRequiredDialog(String categoryName, int requiredScore, int userScore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.lock, color: brandPurple, size: 28),
          const SizedBox(width: 8),
          const Text('Score Required'),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You need $requiredScore points to unlock $categoryName!'),
            const SizedBox(height: 12),
            Text('Earn ${requiredScore - userScore} more points.', style: TextStyle(color: brandTextLight)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Keep Playing', style: TextStyle(color: brandWhite)),
          ),
        ],
      ),
    );
  }

  bool _isCategoryLocked(Category category, int userScore, bool isPremium) {
    if (isPremium) return false;
    if (category.isPremium) return true;
    if (category.requiredScore > userScore) return true;
    return false;
  }

  void _onBottomNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    if (index == 0) Navigator.pushReplacementNamed(context, '/');
    if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        int userScore = 0;
        bool isPremium = false;
        
        if (authState is AuthAuthenticated) {
          userScore = authState.user.totalScore;
          isPremium = authState.user.isPremium;
        }

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
                Text('Categories', style: TextStyle(color: brandTextDark, fontSize: 20, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: brandYellow, borderRadius: BorderRadius.circular(999)),
                  child: Row(children: [
                    const Icon(Icons.star_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text('$userScore', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ],
            ),
          ),
          body: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, categoryState) {
              // Loading state
              if (categoryState is CategoryLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: brandPurple),
                      const SizedBox(height: 16),
                      Text('Loading categories...', style: TextStyle(color: brandTextLight)),
                    ],
                  ),
                );
              }
              
              // Error state
              if (categoryState is CategoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: brandRed),
                      const SizedBox(height: 16),
                      Text(categoryState.message, style: TextStyle(color: brandTextLight)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<CategoryCubit>().loadCategories(),
                        style: ElevatedButton.styleFrom(backgroundColor: brandPurple),
                        child: Text('Retry', style: TextStyle(color: brandWhite)),
                      ),
                    ],
                  ),
                );
              }
              
              // Loaded state - show categories from database
              if (categoryState is CategoryLoaded) {
                final categories = categoryState.categories;
                
                // Empty state - no categories in database
                if (categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category_outlined, size: 80, color: brandTextLight.withOpacity(0.5)),
                        const SizedBox(height: 24),
                        Text(
                          'No Categories Yet',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: brandTextDark),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Categories will appear here once added to the database',
                          style: TextStyle(color: brandTextLight),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => context.read<CategoryCubit>().loadCategories(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandPurple,
                            foregroundColor: brandWhite,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Display categories from database
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isLocked = _isCategoryLocked(category, userScore, isPremium);
                      final isSelected = _selectedCategoryId == category.id;
                      
                      return _CategoryCard(
                        category: category,
                        icon: _getCategoryIcon(category.name),
                        color: _parseColor(category.color),
                        isSelected: isSelected,
                        isLocked: isLocked,
                        isPremiumLocked: category.isPremium && !isPremium,
                        onTap: () => _onCategoryTap(category, userScore, isPremium),
                      );
                    },
                  ),
                );
              }
              
              // Initial state
              return Center(child: CircularProgressIndicator(color: brandPurple));
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: brandWhite,
            selectedItemColor: brandPurple,
            unselectedItemColor: brandTextLight,
            onTap: _onBottomNavTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool isLocked;
  final bool isPremiumLocked;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.isLocked = false,
    this.isPremiumLocked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 48) / 2;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.2 : 0.1),
              blurRadius: isSelected ? 15 : 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected ? Border.all(color: brandPurple, width: 3) : null,
        ),
        child: Stack(
          children: [
            // Category image from database
            if (category.imageUrl != null && category.imageUrl!.isNotEmpty)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    category.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(child: Icon(icon, size: cardSize * 0.4, color: brandWhite.withOpacity(0.5))),
                    ),
                  ),
                ),
              ),
            
            // Overlay gradient
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
                  Icon(icon, color: isLocked ? brandWhite.withOpacity(0.6) : brandWhite, size: cardSize * 0.2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(color: brandWhite, fontSize: cardSize * 0.12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (category.requiredScore > 0 && !category.isPremium)
                        Text(
                          '${category.requiredScore} pts required',
                          style: TextStyle(color: brandYellow, fontSize: cardSize * 0.07, fontWeight: FontWeight.w600),
                        ),
                      if (category.isPremium)
                        Row(
                          children: [
                            Icon(Icons.workspace_premium, color: brandYellow, size: cardSize * 0.08),
                            const SizedBox(width: 4),
                            Text(
                              'Premium',
                              style: TextStyle(color: brandYellow, fontSize: cardSize * 0.07, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Lock icon
            if (isLocked)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPremiumLocked ? Icons.workspace_premium : Icons.lock,
                    color: isPremiumLocked ? brandYellow : brandWhite,
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

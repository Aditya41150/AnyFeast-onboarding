import 'package:flutter/material.dart';
import 'completion_screen.dart';

class CuisinePreferencesScreen extends StatefulWidget {
  final List<String> selectedGoals;
  final String selectedDiet;
  final List<String> selectedAllergies;

  const CuisinePreferencesScreen({
    super.key,
    required this.selectedGoals,
    required this.selectedDiet,
    required this.selectedAllergies,
  });

  @override
  State<CuisinePreferencesScreen> createState() =>
      _CuisinePreferencesScreenState();
}

class _CuisinePreferencesScreenState extends State<CuisinePreferencesScreen> {
  final Set<String> _selectedCuisines = {};

  final List<CuisineOption> _cuisines = [
    CuisineOption(id: 'indian', title: 'Indian', emoji: '🍛', color: Color(0xFFFF6B35)),
    CuisineOption(id: 'italian', title: 'Italian', emoji: '🍝', color: Color(0xFF2EC4B6)),
    CuisineOption(id: 'chinese', title: 'Chinese', emoji: '🥡', color: Color(0xFFE71D36)),
    CuisineOption(id: 'mexican', title: 'Mexican', emoji: '🌮', color: Color(0xFFF77F00)),
    CuisineOption(id: 'japanese', title: 'Japanese', emoji: '🍣', color: Color(0xFFD62828)),
    CuisineOption(id: 'thai', title: 'Thai', emoji: '🍜', color: Color(0xFF06A77D)),
    CuisineOption(id: 'mediterranean', title: 'Mediterranean', emoji: '🥗', color: Color(0xFF4361EE)),
    CuisineOption(id: 'american', title: 'American', emoji: '🍔', color: Color(0xFFD90429)),
    CuisineOption(id: 'french', title: 'French', emoji: '🥐', color: Color(0xFF6C63FF)),
    CuisineOption(id: 'korean', title: 'Korean', emoji: '🍲', color: Color(0xFFEF476F)),
    CuisineOption(id: 'middle_eastern', title: 'Middle Eastern', emoji: '🥙', color: Color(0xFFFFB703)),
    CuisineOption(id: 'greek', title: 'Greek', emoji: '🫒', color: Color(0xFF118AB2)),
  ];

  void _toggleCuisine(String cuisineId) {
    setState(() {
      if (_selectedCuisines.contains(cuisineId)) {
        _selectedCuisines.remove(cuisineId);
      } else {
        _selectedCuisines.add(cuisineId);
      }
    });
  }

  void _continue() {
    if (_selectedCuisines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one cuisine'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CompletionScreen(
          selectedGoals: widget.selectedGoals,
          selectedDiet: widget.selectedDiet,
          selectedAllergies: widget.selectedAllergies,
          selectedCuisines: _selectedCuisines.toList(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF6C63FF),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '3/3',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Favorite\nCuisines',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select cuisines you love. We\'ll recommend recipes accordingly.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Cuisines Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: _cuisines.length,
                      itemBuilder: (context, index) {
                        final cuisine = _cuisines[index];
                        final isSelected = _selectedCuisines.contains(cuisine.id);
                        return _buildCuisineCard(cuisine, isSelected);
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // Continue Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCuisines.isEmpty
                        ? Colors.grey[300]
                        : const Color(0xFF6C63FF),
                    foregroundColor: _selectedCuisines.isEmpty
                        ? Colors.grey[500]
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Complete Setup',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuisineCard(CuisineOption cuisine, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleCuisine(cuisine.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? cuisine.color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? cuisine.color : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cuisine.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cuisine.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              cuisine.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CuisineOption {
  final String id;
  final String title;
  final String emoji;
  final Color color;

  CuisineOption({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
  });
}

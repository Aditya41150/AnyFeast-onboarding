import 'package:flutter/material.dart';
import 'cuisine_preferences_screen.dart';

class DietaryPreferencesScreen extends StatefulWidget {
  final List<String> selectedGoals;

  const DietaryPreferencesScreen({
    super.key,
    required this.selectedGoals,
  });

  @override
  State<DietaryPreferencesScreen> createState() =>
      _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends State<DietaryPreferencesScreen> {
  String? _selectedDiet;
  final Set<String> _selectedAllergies = {};

  final List<DietOption> _diets = [
    DietOption(
      id: 'none',
      icon: Icons.restaurant,
      title: 'No Restrictions',
      description: 'I eat everything',
    ),
    DietOption(
      id: 'vegetarian',
      icon: Icons.eco,
      title: 'Vegetarian',
      description: 'No meat or fish',
    ),
    DietOption(
      id: 'vegan',
      icon: Icons.spa,
      title: 'Vegan',
      description: 'Plant-based only',
    ),
    DietOption(
      id: 'pescatarian',
      icon: Icons.set_meal,
      title: 'Pescatarian',
      description: 'Fish but no meat',
    ),
    DietOption(
      id: 'keto',
      icon: Icons.local_fire_department,
      title: 'Keto',
      description: 'Low-carb, high-fat',
    ),
    DietOption(
      id: 'paleo',
      icon: Icons.nature_people,
      title: 'Paleo',
      description: 'Whole foods focused',
    ),
  ];

  final List<AllergyOption> _allergies = [
    AllergyOption(id: 'dairy', title: 'Dairy', icon: '🥛'),
    AllergyOption(id: 'eggs', title: 'Eggs', icon: '🥚'),
    AllergyOption(id: 'nuts', title: 'Nuts', icon: '🥜'),
    AllergyOption(id: 'soy', title: 'Soy', icon: '🫘'),
    AllergyOption(id: 'gluten', title: 'Gluten', icon: '🌾'),
    AllergyOption(id: 'shellfish', title: 'Shellfish', icon: '🦐'),
    AllergyOption(id: 'fish', title: 'Fish', icon: '🐟'),
    AllergyOption(id: 'sesame', title: 'Sesame', icon: '🌰'),
  ];

  void _toggleAllergy(String allergyId) {
    setState(() {
      if (_selectedAllergies.contains(allergyId)) {
        _selectedAllergies.remove(allergyId);
      } else {
        _selectedAllergies.add(allergyId);
      }
    });
  }

  void _continue() {
    if (_selectedDiet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select your dietary preference'),
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
            CuisinePreferencesScreen(
          selectedGoals: widget.selectedGoals,
          selectedDiet: _selectedDiet!,
          selectedAllergies: _selectedAllergies.toList(),
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
                          value: 0.66,
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
                        '2/3',
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
                    'Dietary\nPreferences',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Help us understand your dietary needs',
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
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Diet Type
                    const Text(
                      'I follow a...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _diets.map((diet) {
                        final isSelected = _selectedDiet == diet.id;
                        return _buildDietChip(diet, isSelected);
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    // Allergies
                    const Text(
                      'Allergies & Intolerances',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select any that apply (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _allergies.map((allergy) {
                        final isSelected = _selectedAllergies.contains(allergy.id);
                        return _buildAllergyChip(allergy, isSelected);
                      }).toList(),
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
                    backgroundColor: _selectedDiet == null
                        ? Colors.grey[300]
                        : const Color(0xFF6C63FF),
                    foregroundColor:
                        _selectedDiet == null ? Colors.grey[500] : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue',
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

  Widget _buildDietChip(DietOption diet, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedDiet = diet.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              diet.icon,
              size: 24,
              color: isSelected ? Colors.white : const Color(0xFF6C63FF),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diet.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  diet.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyChip(AllergyOption allergy, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleAllergy(allergy.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEC4899) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFEC4899) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              allergy.icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              allergy.title,
              style: TextStyle(
                fontSize: 14,
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

class DietOption {
  final String id;
  final IconData icon;
  final String title;
  final String description;

  DietOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class AllergyOption {
  final String id;
  final String title;
  final String icon;

  AllergyOption({
    required this.id,
    required this.title,
    required this.icon,
  });
}

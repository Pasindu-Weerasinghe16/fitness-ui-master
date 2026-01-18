import 'package:flutter/material.dart';
import '../../../services/nutrition_tracking_service.dart';

class MealSelectionPage extends StatefulWidget {
  final String mealType;
  final DateTime selectedDate;

  const MealSelectionPage({
    super.key,
    required this.mealType,
    required this.selectedDate,
  });

  @override
  State<MealSelectionPage> createState() => _MealSelectionPageState();
}

class _MealSelectionPageState extends State<MealSelectionPage> {
  final NutritionTrackingService _nutritionService = NutritionTrackingService();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<String> get categories => ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snack', 'Drink'];

  List<MealTemplate> get filteredMeals {
    List<MealTemplate> meals = NutritionTrackingService.mealDatabase;
    
    if (_selectedCategory != 'All') {
      meals = meals.where((m) => m.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      meals = _nutritionService.searchMeals(_searchQuery);
    }
    
    return meals;
  }

  @override
  void initState() {
    super.initState();
    // Default to the current meal type category when possible.
    if (categories.contains(widget.mealType)) {
      _selectedCategory = widget.mealType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add to ${widget.mealType}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search meals...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Category chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: theme.cardColor,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Meal list
          Expanded(
            child: filteredMeals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No meals found',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return _mealCard(theme, meal);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _mealCard(ThemeData theme, MealTemplate meal) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final ts = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          now.hour,
          now.minute,
          now.second,
          now.millisecond,
          now.microsecond,
        );

        // Add meal
        final entry = MealEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: meal.name,
          mealType: widget.mealType,
          calories: meal.calories,
          carbs: meal.carbs,
          protein: meal.protein,
          fat: meal.fat,
          timestamp: ts,
          imagePath: meal.imagePath,
        );

        await _nutritionService.addMealEntry(entry);

        if (!mounted) return;
        Navigator.pop(context, meal.name);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getCategoryColor(meal.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(meal.category),
                color: _getCategoryColor(meal.category),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meal.calories} kcal • C:${meal.carbs}g P:${meal.protein}g F:${meal.fat}g',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (meal.tags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: meal.tags.take(3).map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
            
            // Add button
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Breakfast':
        return const Color(0xFF4169E1);
      case 'Lunch':
        return const Color(0xFFFFA500);
      case 'Dinner':
        return const Color(0xFF9ACD32);
      case 'Snack':
        return const Color(0xFFFF6B9D);
      case 'Drink':
        return const Color(0xFF00CED1);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Breakfast':
        return Icons.breakfast_dining;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.cookie;
      case 'Drink':
        return Icons.local_cafe;
      default:
        return Icons.restaurant;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

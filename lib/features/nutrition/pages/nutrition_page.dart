import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import '../../../services/nutrition_tracking_service.dart';
import 'meal_selection_page.dart';
import 'meal_detail_page.dart';
import '../../../shared/widgets/add_meal_entry_sheet.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final NutritionTrackingService _nutritionService = NutritionTrackingService();
  
  // Nutrition data
  Map<String, int> nutritionGoals = {};
  Map<String, int> currentNutrition = {};
  List<MealEntry> todayMeals = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  String _mealFilter = 'All';

  final List<String> _mealFilters = const ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snack', 'Drink'];

  @override
  void initState() {
    super.initState();
    _loadNutritionData();
  }

  Future<void> _loadNutritionData() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    final goals = await _nutritionService.getNutritionGoals();
    final nutrition = await _nutritionService.getNutritionForDate(_selectedDate);
    final meals = await _nutritionService.getMealsForDate(_selectedDate);

    if (!mounted) return;
    setState(() {
      nutritionGoals = goals;
      currentNutrition = nutrition;
      todayMeals = meals;
      _isLoading = false;
    });
  }

  Future<void> _openMealSelection(String mealType) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => MealSelectionPage(mealType: mealType),
      ),
    );

    if (!mounted) return;
    if (result != null) {
      await _loadNutritionData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$result added to $mealType'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() => _selectedDate = picked);
    await _loadNutritionData();
  }

  Future<void> _showGoalEditor() async {
    final theme = Theme.of(context);
    final currentGoals = await _nutritionService.getNutritionGoals();

    final caloriesController = TextEditingController(text: '${currentGoals['calories'] ?? 2145}');
    final carbsController = TextEditingController(text: '${currentGoals['carbs'] ?? 268}');
    final proteinController = TextEditingController(text: '${currentGoals['protein'] ?? 107}');
    final fatController = TextEditingController(text: '${currentGoals['fat'] ?? 71}');

    if (!mounted) return;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Macro tracker',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _goalField(theme, label: 'Calories (kcal)', controller: caloriesController),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _goalField(theme, label: 'Carbs (g)', controller: carbsController)),
                    const SizedBox(width: 10),
                    Expanded(child: _goalField(theme, label: 'Protein (g)', controller: proteinController)),
                    const SizedBox(width: 10),
                    Expanded(child: _goalField(theme, label: 'Fat (g)', controller: fatController)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () async {
                      int parseOr(int fallback, TextEditingController c) {
                        final v = int.tryParse(c.text.trim());
                        return v == null || v <= 0 ? fallback : v;
                      }

                      await _nutritionService.setNutritionGoals(
                        calorieGoal: parseOr(2145, caloriesController),
                        carbsGoal: parseOr(268, carbsController),
                        proteinGoal: parseOr(107, proteinController),
                        fatGoal: parseOr(71, fatController),
                      );

                      if (!context.mounted) return;
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Save goals',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );

    caloriesController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    fatController.dispose();

    if (saved == true) {
      await _loadNutritionData();
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName.split(' ').first;
    }
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) {
      final atIndex = email.indexOf('@');
      return atIndex > 0 ? email.substring(0, atIndex) : email;
    }
    return 'there';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
          ),
        ),
      );
    }
    
    final calorieGoal = nutritionGoals['calories'] ?? 2145;
    final currentCalories = currentNutrition['calories'] ?? 0;
    final caloriesLeft = calorieGoal - currentCalories;
    
    final carbsGoal = nutritionGoals['carbs'] ?? 268;
    final carbsCurrent = currentNutrition['carbs'] ?? 0;
    
    final proteinGoal = nutritionGoals['protein'] ?? 107;
    final proteinCurrent = currentNutrition['protein'] ?? 0;
    
    final fatGoal = nutritionGoals['fat'] ?? 71;
    final fatCurrent = currentNutrition['fat'] ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${_getGreeting()}👋',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getUserName(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: _showGoalEditor,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Calorie Progress Ring
              _todayCaloriesMacroCard(
                theme,
                calorieGoal: calorieGoal,
                currentCalories: currentCalories,
                caloriesLeft: caloriesLeft,
                carbsCurrent: carbsCurrent,
                carbsGoal: carbsGoal,
                proteinCurrent: proteinCurrent,
                proteinGoal: proteinGoal,
                fatCurrent: fatCurrent,
                fatGoal: fatGoal,
              ),

              const SizedBox(height: 20),

              // Macros Row
              Row(
                children: [
                  _macroCard(
                    theme,
                    icon: '🥖',
                    label: 'Carbs',
                    current: carbsCurrent,
                    goal: carbsGoal,
                    color: const Color(0xFFFFA500),
                  ),
                  const SizedBox(width: 12),
                  _macroCard(
                    theme,
                    icon: '🥩',
                    label: 'Protein',
                    current: proteinCurrent,
                    goal: proteinGoal,
                    color: const Color(0xFF9ACD32),
                  ),
                  const SizedBox(width: 12),
                  _macroCard(
                    theme,
                    icon: '🥑',
                    label: 'Fat',
                    current: fatCurrent,
                    goal: fatGoal,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Quick add
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick add',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openMealSelection('Breakfast'),
                    child: const Text('Browse'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _mealFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _mealFilters[index];
                    final selected = _mealFilter == filter;
                    return FilterChip(
                      label: Text(filter),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _mealFilter = filter);
                      },
                      backgroundColor: theme.cardColor,
                      selectedColor: theme.colorScheme.primary.withOpacity(0.16),
                      side: BorderSide(
                        color: selected ? theme.colorScheme.primary : theme.dividerColor,
                      ),
                      labelStyle: TextStyle(
                        color: selected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _quickAddCard(
                      theme,
                      title: 'Breakfast',
                      icon: Icons.breakfast_dining,
                      color: const Color(0xFF4169E1),
                      onTap: () => _openMealSelection('Breakfast'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickAddCard(
                      theme,
                      title: 'Lunch',
                      icon: Icons.lunch_dining,
                      color: const Color(0xFFFFA500),
                      onTap: () => _openMealSelection('Lunch'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickAddCard(
                      theme,
                      title: 'Dinner',
                      icon: Icons.dinner_dining,
                      color: const Color(0xFF9ACD32),
                      onTap: () => _openMealSelection('Dinner'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Today's meals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isSameDay(_selectedDate, DateTime.now()) ? 'Today\'s meals' : 'Meals',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, size: 20),
                    onPressed: _pickDate,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (todayMeals.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.restaurant, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No meals yet for this day.',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap below to add your first meal. Then tap the meal to open the details page (photo + macros).',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: _showMealTypePicker,
                          icon: const Icon(Icons.add),
                          label: const Text('Add your first meal', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._buildMealList(theme),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMealTypePicker();
        },
        backgroundColor: theme.colorScheme.primary,
        label: const Text(
          'Add Meal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showMealTypePicker() {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Add meal', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 12),
              _mealTypeTile(theme, title: 'Breakfast', icon: Icons.breakfast_dining, onTap: () => _openFromPicker('Breakfast')),
              _mealTypeTile(theme, title: 'Lunch', icon: Icons.lunch_dining, onTap: () => _openFromPicker('Lunch')),
              _mealTypeTile(theme, title: 'Dinner', icon: Icons.dinner_dining, onTap: () => _openFromPicker('Dinner')),
              _mealTypeTile(theme, title: 'Snack', icon: Icons.cookie, onTap: () => _openFromPicker('Snack')),
              _mealTypeTile(theme, title: 'Drink', icon: Icons.local_cafe, onTap: () => _openFromPicker('Drink')),
              const Divider(),
              _mealTypeTile(
                theme,
                title: 'Create custom meal',
                icon: Icons.edit_note,
                onTap: _openCreateMeal,
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCreateMeal() async {
    Navigator.pop(context);

    final initialType = _mealFilter != 'All' ? _mealFilter : 'Lunch';
    final added = await AddMealEntrySheet.show(
      context,
      service: _nutritionService,
      date: _selectedDate,
      initialMealType: initialType,
    );

    if (!mounted) return;
    if (added != null) {
      await _loadNutritionData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${added.name} added to ${added.mealType}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Widget _mealTypeTile(ThemeData theme, {required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _openFromPicker(String type) {
    Navigator.pop(context);
    _openMealSelection(type);
  }

  List<Widget> _buildMealList(ThemeData theme) {
    final meals = [...todayMeals]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final filtered = _mealFilter == 'All' ? meals : meals.where((m) => m.mealType == _mealFilter).toList();
    if (filtered.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Icon(Icons.filter_alt, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No $_mealFilter meals for this day.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ];
    }

    return filtered.map((meal) {
      return Dismissible(
        key: ValueKey(meal.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.red),
        ),
        onDismissed: (_) async {
          await _nutritionService.removeMealEntry(meal.id);
          await _loadNutritionData();
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final result = await Navigator.of(context).push<MealDetailResult>(
              MaterialPageRoute(
                builder: (_) => MealDetailPage(meal: meal, goals: nutritionGoals),
              ),
            );

            if (!mounted) return;
            if (result?.deleteMealId != null) {
              await _nutritionService.removeMealEntry(result!.deleteMealId!);
              await _loadNutritionData();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _typeColor(meal.mealType).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_typeIcon(meal.mealType), color: _typeColor(meal.mealType)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meal.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(
                        '${meal.mealType} • ${_formatTime(context, meal.timestamp)} • ${meal.calories} kcal',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'C:${meal.carbs}g  P:${meal.protein}g  F:${meal.fat}g',
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: theme.textTheme.bodySmall?.color),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _quickAddCard(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalField(ThemeData theme, {required String label, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatTime(BuildContext context, DateTime dt) {
    final tod = TimeOfDay.fromDateTime(dt);
    return MaterialLocalizations.of(context).formatTimeOfDay(tod);
  }

  Color _typeColor(String mealType) {
    switch (mealType) {
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

  IconData _typeIcon(String mealType) {
    switch (mealType) {
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

  Widget _macroCard(
    ThemeData theme, {
    required String icon,
    required String label,
    required int current,
    required int goal,
    required Color color,
  }) {
    return Expanded(
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              '$current',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              '/$goal',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todayCaloriesMacroCard(
    ThemeData theme, {
    required int calorieGoal,
    required int currentCalories,
    required int caloriesLeft,
    required int carbsCurrent,
    required int carbsGoal,
    required int proteinCurrent,
    required int proteinGoal,
    required int fatCurrent,
    required int fatGoal,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE9ECF3);
    final trackColor = isDark ? Colors.white.withOpacity(0.12) : const Color(0xFFE6EAF3);
    final dotColor = isDark ? Colors.white.withOpacity(0.16) : const Color(0xFFD7DCE9);

    final safeCalorieGoal = calorieGoal <= 0 ? 1 : calorieGoal;
    final caloriesProgress = (currentCalories / safeCalorieGoal).clamp(0.0, 1.0);

    final safeCarbsGoal = carbsGoal <= 0 ? 1 : carbsGoal;
    final safeProteinGoal = proteinGoal <= 0 ? 1 : proteinGoal;
    final safeFatGoal = fatGoal <= 0 ? 1 : fatGoal;

    final carbsProgress = (carbsCurrent / safeCarbsGoal).clamp(0.0, 1.0);
    final proteinProgress = (proteinCurrent / safeProteinGoal).clamp(0.0, 1.0);
    final fatProgress = (fatCurrent / safeFatGoal).clamp(0.0, 1.0);

    const carbsColor = Color(0xFFFFA500);
    const proteinColor = Color(0xFF9ACD32);
    final fatColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.24) : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Today calories',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F2F7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  '${caloriesLeft < 0 ? 0 : caloriesLeft} left',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: CustomPaint(
                painter: _TripleMacroRingPainter(
                  dotColor: dotColor,
                  trackColor: trackColor,
                  caloriesProgress: caloriesProgress,
                  caloriesColor: theme.colorScheme.primary,
                  carbsProgress: carbsProgress,
                  carbsColor: carbsColor,
                  proteinProgress: proteinProgress,
                  proteinColor: proteinColor,
                  fatProgress: fatProgress,
                  fatColor: fatColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.18 : 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(Icons.local_fire_department, color: theme.colorScheme.primary, size: 26),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'CALORIES',
                        style: theme.textTheme.labelLarge?.copyWith(
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w800,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$currentCalories',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'kcal',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Goal $safeCalorieGoal',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MacroLegendItem(
                color: carbsColor,
                label: 'Carbs',
                value: '$carbsCurrent/$safeCarbsGoal g',
              ),
              _MacroLegendItem(
                color: proteinColor,
                label: 'Protein',
                value: '$proteinCurrent/$safeProteinGoal g',
              ),
              _MacroLegendItem(
                color: fatColor,
                label: 'Fat',
                value: '$fatCurrent/$safeFatGoal g',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // legacy placeholder widgets removed; UI is now driven by saved meals and goals.
}

class _MacroLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _MacroLegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
          ),
        ),
      ],
    );
  }
}

class _TripleMacroRingPainter extends CustomPainter {
  final Color dotColor;
  final Color trackColor;

  final double caloriesProgress;
  final Color caloriesColor;

  final double carbsProgress;
  final Color carbsColor;

  final double proteinProgress;
  final Color proteinColor;

  final double fatProgress;
  final Color fatColor;

  _TripleMacroRingPainter({
    required this.dotColor,
    required this.trackColor,
    required this.caloriesProgress,
    required this.caloriesColor,
    required this.carbsProgress,
    required this.carbsColor,
    required this.proteinProgress,
    required this.proteinColor,
    required this.fatProgress,
    required this.fatColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = math.min(size.width, size.height) / 2 - 12;

    // Outer dotted ring
    final dotCount = 64;
    final dotRadius = outerRadius + 10;
    final dotPaint = Paint()..color = dotColor;
    for (var i = 0; i < dotCount; i++) {
      final t = (2 * math.pi * i) / dotCount;
      final p = Offset(
        center.dx + dotRadius * math.cos(t),
        center.dy + dotRadius * math.sin(t),
      );
      canvas.drawCircle(p, 1.7, dotPaint);
    }

    final startAngle = math.pi * 0.85;
    final totalSweep = math.pi * 1.30;
    const stroke = 14.0;
    const gap = 10.0;

    void ring(double radius, double progress, Color color) {
      final rect = Rect.fromCircle(center: center, radius: radius);

      final trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, totalSweep, false, trackPaint);

      final progPaint = Paint()
        ..shader = LinearGradient(
          colors: [color.withOpacity(0.95), color.withOpacity(0.55)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, totalSweep * progress, false, progPaint);
    }

    ring(outerRadius, caloriesProgress, caloriesColor);
    ring(outerRadius - (stroke + gap), carbsProgress, carbsColor);
    ring(outerRadius - 2 * (stroke + gap), proteinProgress, proteinColor);
    ring(outerRadius - 3 * (stroke + gap), fatProgress, fatColor);
  }

  @override
  bool shouldRepaint(_TripleMacroRingPainter oldDelegate) {
    return oldDelegate.caloriesProgress != caloriesProgress ||
        oldDelegate.carbsProgress != carbsProgress ||
        oldDelegate.proteinProgress != proteinProgress ||
        oldDelegate.fatProgress != fatProgress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.dotColor != dotColor;
  }
}

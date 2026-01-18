import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/shared/widgets/circular_progress_card.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  // Daily nutrition goals
  final int calorieGoal = 2145;
  int currentCalories = 1410;
  
  // Macros
  int carbsCurrent = 231;
  int carbsGoal = 412;
  int proteinCurrent = 51;
  int proteinGoal = 132;
  int fatCurrent = 131;
  int fatGoal = 200;

  // Meals data
  final List<Map<String, dynamic>> todayMeals = [
    {'time': '6:30 AM', 'name': 'Morning Drink', 'calories': 50, 'completed': true, 'color': Color(0xFF9ACD32)},
    {'time': '8:00 AM', 'name': 'Breakfast', 'calories': 344, 'completed': true, 'color': Color(0xFF4169E1)},
    {'time': '10:00 AM', 'name': 'Morning Snack', 'calories': 144, 'completed': false, 'color': Color(0xFFFFA500)},
    {'time': '1:30 PM', 'name': 'Lunch', 'calories': 320, 'completed': true, 'color': Color(0xFF4169E1)},
    {'time': '7:30 PM', 'name': 'Evening Snack', 'calories': 300, 'completed': false, 'color': Color(0xFFFFA500)},
    {'time': '9:00 PM', 'name': 'Dinner', 'calories': 552, 'completed': true, 'color': Color(0xFF9ACD32)},
    {'time': '9:45 PM', 'name': 'Night Drink', 'calories': 70, 'completed': false, 'color': Color(0xFFFFA500)},
  ];

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
    final caloriesLeft = calorieGoal - currentCalories;

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
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Calorie Progress Ring
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today calorie',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 160,
                              child: CircularProgressIndicator(
                                value: currentCalories / calorieGoal,
                                strokeWidth: 12,
                                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$currentCalories',
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 40,
                                  ),
                                ),
                                Text(
                                  'kcal',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$calorieGoal\nleft',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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

              // Meal Suggest Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meal Suggest',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Breakfast Card
              _mealSuggestCard(
                theme,
                mealType: 'Breakfast',
                icon: '☕',
                calories: 344,
                color: const Color(0xFFE3F2FD),
                items: [
                  {'name': 'Sandwich', 'kcal': 142, 'selected': true},
                ],
                totalCalories: 142,
                caloriesLeft: 195,
              ),

              const SizedBox(height: 12),

              // Lunch Card
              _mealSuggestCard(
                theme,
                mealType: 'Lunch',
                icon: '🍱',
                calories: 320,
                color: const Color(0xFFEDE7F6),
                items: [
                  {'name': 'Fried Rice', 'kcal': 102, 'selected': true},
                ],
                totalCalories: 102,
                caloriesLeft: 210,
              ),

              const SizedBox(height: 28),

              // Today's Activity Timeline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Activity',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Meal Timeline
              ...todayMeals.map((meal) => _mealTimelineItem(
                theme,
                time: meal['time'],
                name: meal['name'],
                calories: meal['calories'],
                completed: meal['completed'],
                color: meal['color'],
              )).toList(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddMealSheet(context);
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

  Widget _mealSuggestCard(
    ThemeData theme, {
    required String mealType,
    required String icon,
    required int calories,
    required Color color,
    required List<Map<String, dynamic>> items,
    required int totalCalories,
    required int caloriesLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealType,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '🔥 $calories kcal',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                color: theme.colorScheme.primary,
                onPressed: () {
                  _showAddMealSheet(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '🔥 ${item['kcal']} kcal',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (item['selected'])
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          )).toList(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total calories',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '$caloriesLeft left',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: totalCalories / calories,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealTimelineItem(
    ThemeData theme, {
    required String time,
    required String name,
    required int calories,
    required bool completed,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              time.split(' ')[0],
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 2,
            height: 50,
            color: color.withOpacity(0.3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: completed ? color.withOpacity(0.1) : theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: completed ? color : theme.dividerColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      completed ? Icons.check : Icons.restaurant,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$calories kcal',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: completed,
                    onChanged: (value) {
                      setState(() {
                        final mealIndex = todayMeals.indexWhere((m) => m['name'] == name);
                        if (mealIndex != -1) {
                          todayMeals[mealIndex]['completed'] = value ?? false;
                          if (value == true) {
                            currentCalories += calories;
                          } else {
                            currentCalories -= calories;
                          }
                        }
                      });
                    },
                    activeColor: color,
                    shape: const CircleBorder(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMealSheet(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Add Breakfast',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/image001.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Breakfast',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Calorie',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              '213 kcal',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Morning Delight',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _nutritionBadge(theme, '🥬', 'Vegetables'),
                        const SizedBox(width: 12),
                        _nutritionBadge(theme, '🥩', 'Protein'),
                        const SizedBox(width: 12),
                        _nutritionBadge(theme, '🍞', 'Carbs'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI suggest',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Add fruits and vegetables to your breakfast to complete daily nutrition.',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionBadge(ThemeData theme, String icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

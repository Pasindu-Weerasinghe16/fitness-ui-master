import 'package:flutter/material.dart';
import '../../../services/nutrition_tracking_service.dart';

class MealDetailPage extends StatelessWidget {
  final MealEntry meal;
  final Map<String, int> goals;

  const MealDetailPage({
    super.key,
    required this.meal,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final calorieGoal = goals['calories'] ?? 2145;
    final carbsGoal = goals['carbs'] ?? 268;
    final proteinGoal = goals['protein'] ?? 107;
    final fatGoal = goals['fat'] ?? 71;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          meal.mealType,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Remove meal?'),
                    content: Text('Delete “${meal.name}” from your day?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (confirmed != true) return;
              if (!context.mounted) return;
              Navigator.pop(context, MealDetailResult.delete(meal.id));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  meal.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              meal.name,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              _formatMeta(context, meal),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            _bigStatCard(
              theme,
              title: 'Calories',
              value: '${meal.calories}',
              unit: 'kcal',
              subtitle: 'Daily goal: $calorieGoal kcal',
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _macroCard(
                    theme,
                    label: 'Carbs',
                    value: meal.carbs,
                    goal: carbsGoal,
                    color: const Color(0xFFFFA500),
                    icon: Icons.bakery_dining,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _macroCard(
                    theme,
                    label: 'Protein',
                    value: meal.protein,
                    goal: proteinGoal,
                    color: const Color(0xFF9ACD32),
                    icon: Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _macroCard(
                    theme,
                    label: 'Fat',
                    value: meal.fat,
                    goal: fatGoal,
                    color: theme.colorScheme.primary,
                    icon: Icons.opacity,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI suggest', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          _aiTipForMeal(meal),
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
    );
  }

  String _formatMeta(BuildContext context, MealEntry meal) {
    final date = MaterialLocalizations.of(context).formatShortDate(meal.timestamp);
    final time = MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(meal.timestamp));
    return '$date • $time';
  }

  String _aiTipForMeal(MealEntry meal) {
    // Lightweight, deterministic suggestions based on macro balance.
    if (meal.protein < 10) {
      return 'Add a protein source (eggs, yogurt, chicken, tofu) to stay fuller longer.';
    }
    if (meal.fat > 25) {
      return 'This meal is higher in fat. Balance it with vegetables and lean protein.';
    }
    if (meal.carbs > 60) {
      return 'This meal is higher in carbs. Add fiber (fruits/vegetables) to stabilize energy.';
    }
    return 'Nice balance! Add a fruit or vegetables to improve micronutrients.';
  }

  Widget _bigStatCard(
    ThemeData theme, {
    required String title,
    required String value,
    required String unit,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.local_fire_department, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodySmall),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(unit, style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroCard(
    ThemeData theme, {
    required String label,
    required int value,
    required int goal,
    required Color color,
    required IconData icon,
  }) {
    final progress = goal <= 0 ? 0.0 : (value / goal).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Text('${(progress * 100).round()}%', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text('$value g', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: color)),
          Text('/$goal g', style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class MealDetailResult {
  final String? deleteMealId;

  const MealDetailResult._({required this.deleteMealId});

  factory MealDetailResult.delete(String mealId) {
    return MealDetailResult._(deleteMealId: mealId);
  }
}

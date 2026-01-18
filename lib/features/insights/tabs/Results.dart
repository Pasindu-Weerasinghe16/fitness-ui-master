import 'package:flutter/material.dart';

import 'package:fitness_flutter/shared/widgets/Header.dart';
import 'package:fitness_flutter/services/insights_service.dart';
import 'package:fitness_flutter/features/insights/widgets/simple_charts.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  final InsightsService _insights = InsightsService();

  bool _loading = true;
  List<DailyInsight> _last14 = const [];
  TrendPrediction? _prediction;
  WeeklyPlans? _weeklyPlans;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final history = await _insights.getLastNDays(14);
    final prediction = _insights.predictNext7Days(history);
    final plans = await _insights.getOrGeneratePlansForThisWeek();

    if (!mounted) return;
    setState(() {
      _last14 = history;
      _prediction = prediction;
      _weeklyPlans = plans;
      _loading = false;
    });
  }

  Future<void> _regeneratePlans() async {
    setState(() => _loading = true);
    final plans = await _insights.getOrGeneratePlansForThisWeek(regenerate: true);
    if (!mounted) return;
    setState(() {
      _weeklyPlans = plans;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Header('Insights'),
              const SizedBox(height: 28),
              Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary)),
              ),
            ],
          ),
        ),
      );
    }

    final last7 = _last14.length >= 7 ? _last14.sublist(_last14.length - 7) : _last14;
    final caloriesIn7 = last7.map((d) => d.caloriesIn).toList();
    final workouts7 = last7.map((d) => d.workouts).toList();
    final active7 = last7.map((d) => d.activeMinutes).toList();
    final burned7 = last7.map((d) => d.caloriesBurned).toList();

    final weekCaloriesIn = caloriesIn7.fold<int>(0, (s, v) => s + v);
    final weekWorkouts = workouts7.fold<int>(0, (s, v) => s + v);
    final weekActive = active7.fold<int>(0, (s, v) => s + v);
    final weekBurned = burned7.fold<int>(0, (s, v) => s + v);

    final prediction = _prediction;
    final plans = _weeklyPlans;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Header('Insights'),
                const SizedBox(height: 12),

                // Overview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _card(
                    theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('This week', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                            IconButton(
                              onPressed: _load,
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Refresh',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _chip(theme, Icons.local_fire_department, 'Calories in', '$weekCaloriesIn kcal'),
                            _chip(theme, Icons.fitness_center, 'Workouts', '$weekWorkouts sessions'),
                            _chip(theme, Icons.timer_outlined, 'Active', '$weekActive min'),
                            _chip(theme, Icons.whatshot_outlined, 'Burned', '$weekBurned kcal'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Charts
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _chartCard(
                          theme,
                          title: 'Calories in (7d)',
                          subtitle: 'From meals you logged',
                          child: SimpleLineChart(
                            values: caloriesIn7.map((e) => e.toDouble()).toList(),
                            color: theme.colorScheme.primary,
                            height: 110,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _chartCard(
                          theme,
                          title: 'Workouts (7d)',
                          subtitle: 'Sessions per day',
                          child: SimpleBarChart(
                            values: workouts7.map((e) => e.toDouble()).toList(),
                            color: theme.colorScheme.secondary,
                            height: 110,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _chartCard(
                          theme,
                          title: 'Active minutes (7d)',
                          subtitle: 'Time you trained',
                          child: SimpleBarChart(
                            values: active7.map((e) => e.toDouble()).toList(),
                            color: const Color(0xFF10B981),
                            height: 110,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _chartCard(
                          theme,
                          title: 'Calories burned (7d)',
                          subtitle: 'From workouts',
                          child: SimpleLineChart(
                            values: burned7.map((e) => e.toDouble()).toList(),
                            color: const Color(0xFFF59E0B),
                            height: 110,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ML / Trend model
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _card(
                    theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text('AI analysis', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(prediction?.modelName ?? 'Trend model', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _chip(theme, Icons.local_fire_department, 'Next 7d avg in', '${(prediction?.caloriesInNext7Avg ?? 0).round()} kcal/day'),
                            _chip(theme, Icons.fitness_center, 'Next 7d avg workouts', '${(prediction?.workoutsNext7Avg ?? 0).toStringAsFixed(1)}/day'),
                            _chip(theme, Icons.whatshot_outlined, 'Next 7d avg burned', '${(prediction?.caloriesBurnedNext7Avg ?? 0).round()} kcal/day'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(_suggestionText(last7), style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Weekly plans
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _card(
                    theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Weekly plans', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                            TextButton.icon(
                              onPressed: _regeneratePlans,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Regenerate'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _planButton(
                                theme,
                                title: 'Meal plan',
                                subtitle: '7 days (auto-balanced)',
                                icon: Icons.restaurant_menu,
                                color: theme.colorScheme.primary,
                                onTap: plans == null ? null : () => _showMealPlan(context, plans.meals),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _planButton(
                                theme,
                                title: 'Workout plan',
                                subtitle: '5 workouts + recovery',
                                icon: Icons.fitness_center,
                                color: theme.colorScheme.secondary,
                                onTap: plans == null ? null : () => _showWorkoutPlan(context, plans.workouts),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _suggestionText(List<DailyInsight> last7) {
    if (last7.isEmpty) return 'Start logging meals and workouts to get personalized insights.';

    final avgIn = last7.map((d) => d.caloriesIn).reduce((a, b) => a + b) / last7.length;
    final avgWorkouts = last7.map((d) => d.workouts).reduce((a, b) => a + b) / last7.length;

    if (avgWorkouts < 0.5) {
      return 'Suggestion: plan 3–4 short workouts next week. Even 20 minutes/day builds consistency.';
    }

    if (avgIn < 900) {
      return 'Suggestion: your logged calories look low. Try logging all meals to improve accuracy.';
    }

    return 'Suggestion: keep the streak going. Aim for consistent meals and 4–5 training days.';
  }

  Widget _card(ThemeData theme, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _chartCard(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(subtitle, style: theme.textTheme.bodySmall),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _planButton(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  void _showMealPlan(BuildContext context, List<PlannedMealDay> plan) {
    final theme = Theme.of(context);
    var localPlan = plan;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Weekly meal plan', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setModalState) {
                    return ListView.builder(
                      itemCount: localPlan.length,
                      itemBuilder: (context, index) {
                        final day = localPlan[index];
                        final title = MaterialLocalizations.of(context).formatFullDate(day.date);
                        final total = day.meals.fold<int>(0, (s, m) => s + m.calories);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: ExpansionTile(
                            title: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                            subtitle: Text('$total kcal • ${day.meals.length} items', style: theme.textTheme.bodySmall),
                            children: day.meals.asMap().entries.map((entry) {
                              final mealIndex = entry.key;
                              final m = entry.value;

                              return ListTile(
                                dense: true,
                                leading: Icon(Icons.restaurant, color: theme.colorScheme.primary),
                                title: Text(m.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                                subtitle: Text('${m.category} • ${m.calories} kcal • C:${m.carbs}g P:${m.protein}g F:${m.fat}g', style: theme.textTheme.bodySmall),
                                trailing: IconButton(
                                  tooltip: 'Remove from plan',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Remove meal?'),
                                          content: Text('Remove “${m.name}” from this day\'s plan?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            FilledButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Remove'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmed != true) return;

                                    final updatedMeals = await _insights.removeMealFromMealPlanForWeek(
                                      anyDayInWeek: day.date,
                                      dayDate: day.date,
                                      mealIndex: mealIndex,
                                    );

                                    if (!mounted) return;
                                    setModalState(() => localPlan = updatedMeals);

                                    final current = _weeklyPlans;
                                    if (current != null) {
                                      setState(() {
                                        _weeklyPlans = WeeklyPlans(meals: updatedMeals, workouts: current.workouts);
                                      });
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWorkoutPlan(BuildContext context, List<PlannedWorkoutDay> plan) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Weekly workout plan', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: plan.length,
                  itemBuilder: (context, index) {
                    final day = plan[index];
                    final title = MaterialLocalizations.of(context).formatFullDate(day.date);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: ExpansionTile(
                        title: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        subtitle: Text('${day.workouts.length} activity', style: theme.textTheme.bodySmall),
                        children: day.workouts
                            .map(
                              (w) => ListTile(
                                dense: true,
                                leading: Icon(Icons.fitness_center, color: theme.colorScheme.secondary),
                                title: Text(w.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                                subtitle: Text('${w.difficulty} • ${w.durationMinutes} min • ~${w.caloriesBurned} kcal', style: theme.textTheme.bodySmall),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _chip(ThemeData theme, IconData icon, String title, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: theme.dividerColor),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodySmall),
            Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    ),
  );
}


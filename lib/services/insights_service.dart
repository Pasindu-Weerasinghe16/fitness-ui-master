import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'nutrition_tracking_service.dart';
import 'workout_tracking_service.dart';

class DailyInsight {
  final DateTime date;
  final int caloriesIn;
  final int carbs;
  final int protein;
  final int fat;
  final int workouts;
  final int activeMinutes;
  final int caloriesBurned;

  const DailyInsight({
    required this.date,
    required this.caloriesIn,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.workouts,
    required this.activeMinutes,
    required this.caloriesBurned,
  });
}

class TrendPrediction {
  final double caloriesInNext7Avg;
  final double workoutsNext7Avg;
  final double caloriesBurnedNext7Avg;
  final String modelName;

  const TrendPrediction({
    required this.caloriesInNext7Avg,
    required this.workoutsNext7Avg,
    required this.caloriesBurnedNext7Avg,
    required this.modelName,
  });
}

class PlannedMealDay {
  final DateTime date;
  final List<MealTemplate> meals;

  const PlannedMealDay({required this.date, required this.meals});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'meals': meals
            .map((m) => {
                  'name': m.name,
                  'category': m.category,
                  'calories': m.calories,
                  'carbs': m.carbs,
                  'protein': m.protein,
                  'fat': m.fat,
                  'imagePath': m.imagePath,
                  'tags': m.tags,
                })
            .toList(),
      };

  factory PlannedMealDay.fromJson(Map<String, dynamic> json) {
    final mealsJson = (json['meals'] as List).cast<Map<String, dynamic>>();
    return PlannedMealDay(
      date: DateTime.parse(json['date']),
      meals: mealsJson
          .map(
            (m) => MealTemplate(
              name: m['name'],
              category: m['category'],
              calories: m['calories'],
              carbs: m['carbs'],
              protein: m['protein'],
              fat: m['fat'],
              imagePath: m['imagePath'] ?? 'assets/images/image001.jpg',
              tags: (m['tags'] as List?)?.cast<String>() ?? const [],
            ),
          )
          .toList(),
    );
  }
}

class PlannedWorkout {
  final String title;
  final String difficulty;
  final int durationMinutes;
  final int caloriesBurned;

  const PlannedWorkout({
    required this.title,
    required this.difficulty,
    required this.durationMinutes,
    required this.caloriesBurned,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'difficulty': difficulty,
        'durationMinutes': durationMinutes,
        'caloriesBurned': caloriesBurned,
      };

  factory PlannedWorkout.fromJson(Map<String, dynamic> json) => PlannedWorkout(
        title: json['title'],
        difficulty: json['difficulty'],
        durationMinutes: json['durationMinutes'],
        caloriesBurned: json['caloriesBurned'],
      );
}

class PlannedWorkoutDay {
  final DateTime date;
  final List<PlannedWorkout> workouts;

  const PlannedWorkoutDay({required this.date, required this.workouts});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'workouts': workouts.map((w) => w.toJson()).toList(),
      };

  factory PlannedWorkoutDay.fromJson(Map<String, dynamic> json) => PlannedWorkoutDay(
        date: DateTime.parse(json['date']),
        workouts: (json['workouts'] as List)
            .cast<Map<String, dynamic>>()
            .map((w) => PlannedWorkout.fromJson(w))
            .toList(),
      );
}

class WeeklyPlans {
  final List<PlannedMealDay> meals;
  final List<PlannedWorkoutDay> workouts;

  const WeeklyPlans({required this.meals, required this.workouts});
}

class InsightsService {
  final NutritionTrackingService nutrition;
  final WorkoutTrackingService workouts;

  InsightsService({
    NutritionTrackingService? nutritionTracking,
    WorkoutTrackingService? workoutTracking,
  })  : nutrition = nutritionTracking ?? NutritionTrackingService(),
        workouts = workoutTracking ?? WorkoutTrackingService();

  static const _mealPlanKeyPrefix = 'weekly_meal_plan_v1';
  static const _workoutPlanKeyPrefix = 'weekly_workout_plan_v1';
  static const _workoutPlanFocusKeyPrefix = 'weekly_workout_plan_focus_v1';

  static const String workoutFocusBalanced = 'Balanced';
  static const String workoutFocusFatLoss = 'Fat loss';
  static const String workoutFocusMuscleGain = 'Muscle gain';
  static const String workoutFocusEndurance = 'Endurance';

  Future<List<DailyInsight>> getLastNDays(int days) async {
    final now = DateTime.now();
    final dates = List.generate(days, (i) {
      final d = now.subtract(Duration(days: days - 1 - i));
      return DateTime(d.year, d.month, d.day);
    });

    final result = <DailyInsight>[];
    for (final date in dates) {
      final n = await nutrition.getNutritionForDate(date);
      final completions = await workouts.getCompletionsForDate(date);

      result.add(
        DailyInsight(
          date: date,
          caloriesIn: n['calories'] ?? 0,
          carbs: n['carbs'] ?? 0,
          protein: n['protein'] ?? 0,
          fat: n['fat'] ?? 0,
          workouts: completions.length,
          activeMinutes: completions.fold<int>(0, (s, c) => s + c.durationMinutes),
          caloriesBurned: completions.fold<int>(0, (s, c) => s + c.caloriesBurned),
        ),
      );
    }

    return result;
  }

  TrendPrediction predictNext7Days(List<DailyInsight> history) {
    // Lightweight on-device “trend model”: linear regression on time index.
    // This avoids heavy ML dependencies and still produces real predictions.
    double predict(List<double> y) {
      if (y.isEmpty) return 0;
      final n = y.length;
      if (n == 1) return y.first;

      // x = 0..n-1
      final xMean = (n - 1) / 2.0;
      final yMean = y.reduce((a, b) => a + b) / n;

      double num = 0;
      double den = 0;
      for (var i = 0; i < n; i++) {
        final dx = i - xMean;
        num += dx * (y[i] - yMean);
        den += dx * dx;
      }

      final slope = den == 0 ? 0 : num / den;
      final intercept = yMean - slope * xMean;

      // Predict for next 7 days and return average.
      double sum = 0;
      for (var i = n; i < n + 7; i++) {
        sum += intercept + slope * i;
      }
      return (sum / 7).clamp(0, double.infinity);
    }

    final caloriesIn = history.map((d) => d.caloriesIn.toDouble()).toList();
    final workoutsCount = history.map((d) => d.workouts.toDouble()).toList();
    final caloriesBurned = history.map((d) => d.caloriesBurned.toDouble()).toList();

    return TrendPrediction(
      caloriesInNext7Avg: predict(caloriesIn),
      workoutsNext7Avg: predict(workoutsCount),
      caloriesBurnedNext7Avg: predict(caloriesBurned),
      modelName: 'On-device Trend Model (Linear Regression)',
    );
  }

  DateTime _startOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  String _weekKey(DateTime date, String prefix) {
    final start = _startOfWeek(date);
    return '$prefix:${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
  }

  Future<String?> loadWorkoutPlanFocusForWeek(DateTime anyDayInWeek) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _weekKey(anyDayInWeek, _workoutPlanFocusKeyPrefix);
    return prefs.getString(key);
  }

  Future<void> saveWorkoutPlanFocusForWeek(DateTime anyDayInWeek, String focus) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _weekKey(anyDayInWeek, _workoutPlanFocusKeyPrefix);
    await prefs.setString(key, focus);
  }

  Future<List<PlannedMealDay>?> loadMealPlanForWeek(DateTime anyDayInWeek) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _weekKey(anyDayInWeek, _mealPlanKeyPrefix);
    final raw = prefs.getString(key);
    if (raw == null) return null;
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map((e) => PlannedMealDay.fromJson(e)).toList();
  }

  Future<void> saveMealPlanForWeek(DateTime anyDayInWeek, List<PlannedMealDay> plan) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _weekKey(anyDayInWeek, _mealPlanKeyPrefix);
    await prefs.setString(key, jsonEncode(plan.map((d) => d.toJson()).toList()));
  }

  Future<List<PlannedWorkoutDay>?> loadWorkoutPlanForWeek(DateTime anyDayInWeek) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _weekKey(anyDayInWeek, _workoutPlanKeyPrefix);
    final raw = prefs.getString(key);
    if (raw == null) return null;
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map((e) => PlannedWorkoutDay.fromJson(e)).toList();
  }

  Future<void> saveWorkoutPlanForWeek(DateTime anyDayInWeek, List<PlannedWorkoutDay> plan) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _weekKey(anyDayInWeek, _workoutPlanKeyPrefix);
    await prefs.setString(key, jsonEncode(plan.map((d) => d.toJson()).toList()));
  }

  Future<List<PlannedMealDay>> generateMealPlanForWeek({required DateTime anyDayInWeek}) async {
    final goals = await nutrition.getNutritionGoals();
    final dailyCalGoal = goals['calories'] ?? 2145;

    final start = _startOfWeek(anyDayInWeek);
    final plan = <PlannedMealDay>[];

    // Use a deterministic seed per week so plans feel stable.
    final seed = start.millisecondsSinceEpoch;
    final rng = Random(seed);

    List<MealTemplate> pick(String category, int count) {
      final pool = NutritionTrackingService.mealDatabase.where((m) => m.category == category).toList();
      if (pool.isEmpty) return [];
      return List.generate(count, (_) => pool[rng.nextInt(pool.length)]);
    }

    for (var i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));

      // Basic structure: breakfast + lunch + dinner + snack.
      // Adjust snack count based on calorie goal.
      final snacks = dailyCalGoal >= 2300 ? 2 : 1;
      final meals = <MealTemplate>[
        ...pick('Breakfast', 1),
        ...pick('Lunch', 1),
        ...pick('Dinner', 1),
        ...pick('Snack', snacks),
      ];

      // If calories are too low/high vs goal, swap one snack with a drink or add a drink.
      final total = meals.fold<int>(0, (s, m) => s + m.calories);
      final diff = dailyCalGoal - total;
      if (diff.abs() > 250) {
        final drinks = NutritionTrackingService.mealDatabase.where((m) => m.category == 'Drink').toList();
        if (drinks.isNotEmpty) {
          meals.add(drinks[rng.nextInt(drinks.length)]);
        }
      }

      plan.add(PlannedMealDay(date: date, meals: meals));
    }

    await saveMealPlanForWeek(anyDayInWeek, plan);
    return plan;
  }

  static const List<PlannedWorkout> _workoutPool = [
    PlannedWorkout(title: 'Morning Stretch', difficulty: 'Beginner', durationMinutes: 15, caloriesBurned: 80),
    PlannedWorkout(title: 'Core Builder', difficulty: 'Beginner', durationMinutes: 20, caloriesBurned: 120),
    PlannedWorkout(title: 'Cardio Blast', difficulty: 'Intermediate', durationMinutes: 25, caloriesBurned: 220),
    PlannedWorkout(title: 'HIIT Cardio', difficulty: 'Intermediate', durationMinutes: 20, caloriesBurned: 250),
    PlannedWorkout(title: 'Strength Circuit', difficulty: 'Intermediate', durationMinutes: 30, caloriesBurned: 280),
    PlannedWorkout(title: 'Heavy Lifting', difficulty: 'Pro', durationMinutes: 45, caloriesBurned: 420),
    PlannedWorkout(title: 'Power Endurance', difficulty: 'Pro', durationMinutes: 40, caloriesBurned: 380),
    PlannedWorkout(title: 'Mobility + Recovery', difficulty: 'Beginner', durationMinutes: 20, caloriesBurned: 70),
    PlannedWorkout(title: 'Full Body Burn', difficulty: 'Intermediate', durationMinutes: 35, caloriesBurned: 330),
    PlannedWorkout(title: 'Athlete Conditioning', difficulty: 'Pro', durationMinutes: 50, caloriesBurned: 480),
  ];

  Future<List<PlannedWorkoutDay>> generateWorkoutPlanForWeek({
    required DateTime anyDayInWeek,
    String focus = 'Balanced',
  }) async {
    final start = _startOfWeek(anyDayInWeek);
    final seed = start.millisecondsSinceEpoch + focus.hashCode;
    final rng = Random(seed);

    // Persist selected focus for this week.
    await saveWorkoutPlanFocusForWeek(anyDayInWeek, focus);

    // 5 workout days + 2 recovery days.
    final workoutDays = <int>{};
    while (workoutDays.length < 5) {
      workoutDays.add(rng.nextInt(7));
    }

    List<PlannedWorkout> pickPool(String focusLabel) {
      bool titleHas(PlannedWorkout w, List<String> needles) {
        final t = w.title.toLowerCase();
        return needles.any((n) => t.contains(n));
      }

      if (focusLabel == workoutFocusFatLoss) {
        final preferred = _workoutPool.where((w) {
          return titleHas(w, ['hiit', 'cardio', 'burn', 'conditioning']);
        }).toList();
        final support = _workoutPool.where((w) {
          return titleHas(w, ['strength', 'core']);
        }).toList();
        return [...preferred, ...preferred, ...support, ..._workoutPool];
      }

      if (focusLabel == workoutFocusMuscleGain) {
        final preferred = _workoutPool.where((w) {
          return titleHas(w, ['strength', 'lifting', 'full body', 'core']);
        }).toList();
        final support = _workoutPool.where((w) {
          return titleHas(w, ['mobility', 'stretch']);
        }).toList();
        return [...preferred, ...preferred, ...preferred, ...support, ..._workoutPool];
      }

      if (focusLabel == workoutFocusEndurance) {
        final preferred = _workoutPool.where((w) {
          return titleHas(w, ['endurance', 'cardio', 'conditioning']);
        }).toList();
        final support = _workoutPool.where((w) {
          return titleHas(w, ['mobility', 'stretch']);
        }).toList();
        return [...preferred, ...preferred, ...support, ..._workoutPool];
      }

      // Balanced
      return [..._workoutPool];
    }

    PlannedWorkout recoveryWorkout(String focusLabel) {
      if (focusLabel == workoutFocusEndurance) {
        return const PlannedWorkout(
          title: 'Recovery Walk (Zone 2)',
          difficulty: 'Recovery',
          durationMinutes: 30,
          caloriesBurned: 110,
        );
      }
      if (focusLabel == workoutFocusFatLoss) {
        return const PlannedWorkout(
          title: 'Recovery Walk + Mobility',
          difficulty: 'Recovery',
          durationMinutes: 30,
          caloriesBurned: 120,
        );
      }
      return const PlannedWorkout(
        title: 'Mobility + Recovery',
        difficulty: 'Recovery',
        durationMinutes: 20,
        caloriesBurned: 70,
      );
    }

    final pool = pickPool(focus);
    final plan = <PlannedWorkoutDay>[];

    for (var i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      if (!workoutDays.contains(i)) {
        plan.add(
          PlannedWorkoutDay(
            date: date,
            workouts: [recoveryWorkout(focus)],
          ),
        );
        continue;
      }

      if (pool.isEmpty) {
        plan.add(
          PlannedWorkoutDay(
            date: date,
            workouts: const [PlannedWorkout(title: 'Bodyweight Session', difficulty: 'Balanced', durationMinutes: 30, caloriesBurned: 240)],
          ),
        );
        continue;
      }

      // One main workout per day.
      plan.add(
        PlannedWorkoutDay(
          date: date,
          workouts: [pool[rng.nextInt(pool.length)]],
        ),
      );
    }

    await saveWorkoutPlanForWeek(anyDayInWeek, plan);
    return plan;
  }

  Future<WeeklyPlans> getOrGeneratePlansForThisWeek({
    bool regenerate = false,
    String? workoutFocus,
  }) async {
    final now = DateTime.now();

    List<PlannedMealDay>? meals;
    List<PlannedWorkoutDay>? workoutPlan;

    var resolvedFocus = workoutFocus;
    resolvedFocus ??= await loadWorkoutPlanFocusForWeek(now);
    resolvedFocus ??= workoutFocusBalanced;

    if (!regenerate) {
      meals = await loadMealPlanForWeek(now);
      workoutPlan = await loadWorkoutPlanForWeek(now);
    }

    meals ??= await generateMealPlanForWeek(anyDayInWeek: now);
    workoutPlan ??= await generateWorkoutPlanForWeek(anyDayInWeek: now, focus: resolvedFocus);

    return WeeklyPlans(meals: meals, workouts: workoutPlan);
  }
}

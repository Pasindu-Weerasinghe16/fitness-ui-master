import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutCompletion {
  final String workoutTitle;
  final DateTime completedAt;
  final int caloriesBurned;
  final int durationMinutes;

  WorkoutCompletion({
    required this.workoutTitle,
    required this.completedAt,
    required this.caloriesBurned,
    required this.durationMinutes,
  });

  Map<String, dynamic> toJson() => {
    'workoutTitle': workoutTitle,
    'completedAt': completedAt.toIso8601String(),
    'caloriesBurned': caloriesBurned,
    'durationMinutes': durationMinutes,
  };

  factory WorkoutCompletion.fromJson(Map<String, dynamic> json) => WorkoutCompletion(
    workoutTitle: json['workoutTitle'],
    completedAt: DateTime.parse(json['completedAt']),
    caloriesBurned: json['caloriesBurned'],
    durationMinutes: json['durationMinutes'],
  );
}

class WorkoutTrackingService {
  static const String _completionsKey = 'workout_completions';

  Future<void> saveWorkoutCompletion(WorkoutCompletion completion) async {
    final prefs = await SharedPreferences.getInstance();
    final completions = await getCompletions();
    completions.add(completion);
    
    final jsonList = completions.map((c) => c.toJson()).toList();
    await prefs.setString(_completionsKey, jsonEncode(jsonList));
  }

  Future<List<WorkoutCompletion>> getCompletions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_completionsKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => WorkoutCompletion.fromJson(json)).toList();
  }

  Future<List<WorkoutCompletion>> getCompletionsForDate(DateTime date) async {
    final completions = await getCompletions();
    return completions.where((c) {
      return c.completedAt.year == date.year &&
             c.completedAt.month == date.month &&
             c.completedAt.day == date.day;
    }).toList();
  }

  Future<int> getCurrentStreak() async {
    final completions = await getCompletions();
    if (completions.isEmpty) return 0;

    // Sort by date descending
    completions.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    int streak = 0;
    DateTime checkDate = todayDate;
    
    while (true) {
      final hasWorkout = completions.any((c) {
        final cDate = DateTime(c.completedAt.year, c.completedAt.month, c.completedAt.day);
        return cDate == checkDate;
      });
      
      if (hasWorkout) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // Allow one day grace (today might not have workout yet)
        if (checkDate == todayDate) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }
    
    return streak;
  }

  Future<int> getBestStreak() async {
    final completions = await getCompletions();
    if (completions.isEmpty) return 0;

    completions.sort((a, b) => a.completedAt.compareTo(b.completedAt));
    
    int maxStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;
    
    for (var completion in completions) {
      final completionDate = DateTime(
        completion.completedAt.year,
        completion.completedAt.month,
        completion.completedAt.day,
      );
      
      if (lastDate == null) {
        currentStreak = 1;
      } else {
        final difference = completionDate.difference(lastDate).inDays;
        if (difference == 1) {
          currentStreak++;
        } else if (difference == 0) {
          // Same day, don't change streak
        } else {
          maxStreak = maxStreak > currentStreak ? maxStreak : currentStreak;
          currentStreak = 1;
        }
      }
      
      lastDate = completionDate;
    }
    
    return maxStreak > currentStreak ? maxStreak : currentStreak;
  }

  Future<int> getWeeklyWorkoutCount() async {
    final completions = await getCompletions();
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    
    final uniqueDays = <String>{};
    for (var completion in completions) {
      if (completion.completedAt.isAfter(startDate)) {
        final dateKey = '${completion.completedAt.year}-${completion.completedAt.month}-${completion.completedAt.day}';
        uniqueDays.add(dateKey);
      }
    }
    
    return uniqueDays.length;
  }

  Future<int> getTodayActiveMinutes() async {
    final today = DateTime.now();
    final completions = await getCompletionsForDate(today);
    return completions.fold<int>(0, (sum, c) => sum + c.durationMinutes);
  }

  Future<int> getTodayCalories() async {
    final today = DateTime.now();
    final completions = await getCompletionsForDate(today);
    return completions.fold<int>(0, (sum, c) => sum + c.caloriesBurned);
  }

  Future<Map<DateTime, List<WorkoutCompletion>>> getCompletionsByMonth(int year, int month) async {
    final completions = await getCompletions();
    final monthCompletions = completions.where((c) {
      return c.completedAt.year == year && c.completedAt.month == month;
    }).toList();
    
    final Map<DateTime, List<WorkoutCompletion>> grouped = {};
    for (var completion in monthCompletions) {
      final dateKey = DateTime(
        completion.completedAt.year,
        completion.completedAt.month,
        completion.completedAt.day,
      );
      
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(completion);
    }
    
    return grouped;
  }
}

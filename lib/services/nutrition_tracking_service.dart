import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MealEntry {
  final String id;
  final String name;
  final String mealType; // Breakfast, Lunch, Dinner, Snack
  final int calories;
  final int carbs;
  final int protein;
  final int fat;
  final DateTime timestamp;
  final String imagePath;

  MealEntry({
    required this.id,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.timestamp,
    this.imagePath = 'assets/images/image001.jpg',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mealType': mealType,
        'calories': calories,
        'carbs': carbs,
        'protein': protein,
        'fat': fat,
        'timestamp': timestamp.toIso8601String(),
        'imagePath': imagePath,
      };

  factory MealEntry.fromJson(Map<String, dynamic> json) => MealEntry(
        id: json['id'],
        name: json['name'],
        mealType: json['mealType'],
        calories: json['calories'],
        carbs: json['carbs'],
        protein: json['protein'],
        fat: json['fat'],
        timestamp: DateTime.parse(json['timestamp']),
        imagePath: json['imagePath'] ?? 'assets/images/image001.jpg',
      );
}

class MealTemplate {
  final String name;
  final String category;
  final int calories;
  final int carbs;
  final int protein;
  final int fat;
  final String imagePath;
  final List<String> tags;

  MealTemplate({
    required this.name,
    required this.category,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.imagePath = 'assets/images/image001.jpg',
    this.tags = const [],
  });
}

class NutritionTrackingService {
  static const String _keyMealEntries = 'meal_entries';
  static const String _keyNutritionGoals = 'nutrition_goals';

  Future<List<MealEntry>> _getAllMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyMealEntries);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => MealEntry.fromJson(json)).toList();
  }

  Future<void> _saveAllMeals(List<MealEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_keyMealEntries, jsonEncode(jsonList));
  }

  // Meal database
  static final List<MealTemplate> mealDatabase = [
    // Breakfast
    MealTemplate(
      name: 'Scrambled Eggs & Toast',
      category: 'Breakfast',
      calories: 344,
      carbs: 28,
      protein: 20,
      fat: 18,
      tags: ['Protein', 'Carbs'],
    ),
    MealTemplate(
      name: 'Oatmeal with Berries',
      category: 'Breakfast',
      calories: 280,
      carbs: 48,
      protein: 10,
      fat: 6,
      tags: ['Carbs', 'Fiber'],
    ),
    MealTemplate(
      name: 'Greek Yogurt Parfait',
      category: 'Breakfast',
      calories: 220,
      carbs: 32,
      protein: 15,
      fat: 4,
      tags: ['Protein', 'Dairy'],
    ),
    MealTemplate(
      name: 'Avocado Toast',
      category: 'Breakfast',
      calories: 310,
      carbs: 35,
      protein: 12,
      fat: 16,
      tags: ['Healthy Fats', 'Carbs'],
    ),
    MealTemplate(
      name: 'Protein Smoothie',
      category: 'Breakfast',
      calories: 285,
      carbs: 38,
      protein: 24,
      fat: 6,
      tags: ['Protein', 'Fruits'],
    ),
    MealTemplate(
      name: 'Pancakes with Syrup',
      category: 'Breakfast',
      calories: 420,
      carbs: 68,
      protein: 10,
      fat: 12,
      tags: ['Carbs', 'Sweet'],
    ),
    
    // Lunch
    MealTemplate(
      name: 'Grilled Chicken Salad',
      category: 'Lunch',
      calories: 320,
      carbs: 18,
      protein: 35,
      fat: 12,
      tags: ['Protein', 'Vegetables'],
    ),
    MealTemplate(
      name: 'Turkey Sandwich',
      category: 'Lunch',
      calories: 380,
      carbs: 42,
      protein: 28,
      fat: 12,
      tags: ['Protein', 'Carbs'],
    ),
    MealTemplate(
      name: 'Quinoa Buddha Bowl',
      category: 'Lunch',
      calories: 410,
      carbs: 52,
      protein: 18,
      fat: 16,
      tags: ['Vegetables', 'Carbs'],
    ),
    MealTemplate(
      name: 'Chicken Wrap',
      category: 'Lunch',
      calories: 395,
      carbs: 38,
      protein: 32,
      fat: 14,
      tags: ['Protein', 'Carbs'],
    ),
    MealTemplate(
      name: 'Pasta Primavera',
      category: 'Lunch',
      calories: 450,
      carbs: 62,
      protein: 16,
      fat: 16,
      tags: ['Carbs', 'Vegetables'],
    ),
    MealTemplate(
      name: 'Tuna Poke Bowl',
      category: 'Lunch',
      calories: 385,
      carbs: 45,
      protein: 28,
      fat: 10,
      tags: ['Protein', 'Carbs'],
    ),
    
    // Dinner
    MealTemplate(
      name: 'Grilled Salmon & Veggies',
      category: 'Dinner',
      calories: 520,
      carbs: 32,
      protein: 42,
      fat: 24,
      tags: ['Protein', 'Healthy Fats'],
    ),
    MealTemplate(
      name: 'Beef Stir Fry',
      category: 'Dinner',
      calories: 480,
      carbs: 48,
      protein: 36,
      fat: 18,
      tags: ['Protein', 'Vegetables'],
    ),
    MealTemplate(
      name: 'Chicken Breast & Rice',
      category: 'Dinner',
      calories: 510,
      carbs: 58,
      protein: 44,
      fat: 10,
      tags: ['Protein', 'Carbs'],
    ),
    MealTemplate(
      name: 'Vegetarian Curry',
      category: 'Dinner',
      calories: 420,
      carbs: 54,
      protein: 14,
      fat: 18,
      tags: ['Vegetables', 'Carbs'],
    ),
    MealTemplate(
      name: 'Grilled Steak & Potatoes',
      category: 'Dinner',
      calories: 620,
      carbs: 45,
      protein: 48,
      fat: 28,
      tags: ['Protein', 'Carbs'],
    ),
    MealTemplate(
      name: 'Shrimp Pasta',
      category: 'Dinner',
      calories: 490,
      carbs: 56,
      protein: 32,
      fat: 16,
      tags: ['Protein', 'Carbs'],
    ),
    
    // Snacks
    MealTemplate(
      name: 'Apple with Peanut Butter',
      category: 'Snack',
      calories: 180,
      carbs: 22,
      protein: 6,
      fat: 8,
      tags: ['Fruits', 'Protein'],
    ),
    MealTemplate(
      name: 'Protein Bar',
      category: 'Snack',
      calories: 220,
      carbs: 24,
      protein: 20,
      fat: 8,
      tags: ['Protein'],
    ),
    MealTemplate(
      name: 'Mixed Nuts',
      category: 'Snack',
      calories: 170,
      carbs: 8,
      protein: 6,
      fat: 14,
      tags: ['Healthy Fats'],
    ),
    MealTemplate(
      name: 'Fruit Smoothie',
      category: 'Snack',
      calories: 150,
      carbs: 32,
      protein: 4,
      fat: 2,
      tags: ['Fruits'],
    ),
    MealTemplate(
      name: 'Veggie Sticks & Hummus',
      category: 'Snack',
      calories: 120,
      carbs: 16,
      protein: 5,
      fat: 4,
      tags: ['Vegetables'],
    ),
    MealTemplate(
      name: 'Cheese & Crackers',
      category: 'Snack',
      calories: 200,
      carbs: 18,
      protein: 8,
      fat: 12,
      tags: ['Dairy', 'Carbs'],
    ),
    
    // Drinks
    MealTemplate(
      name: 'Green Tea',
      category: 'Drink',
      calories: 5,
      carbs: 1,
      protein: 0,
      fat: 0,
      tags: ['Healthy'],
    ),
    MealTemplate(
      name: 'Orange Juice',
      category: 'Drink',
      calories: 110,
      carbs: 26,
      protein: 2,
      fat: 0,
      tags: ['Fruits'],
    ),
    MealTemplate(
      name: 'Protein Shake',
      category: 'Drink',
      calories: 160,
      carbs: 12,
      protein: 25,
      fat: 3,
      tags: ['Protein'],
    ),
    MealTemplate(
      name: 'Coffee with Milk',
      category: 'Drink',
      calories: 60,
      carbs: 8,
      protein: 3,
      fat: 2,
      tags: ['Dairy'],
    ),
  ];

  Future<void> addMealEntry(MealEntry entry) async {
    final entries = await _getAllMeals();
    entries.add(entry);
    await _saveAllMeals(entries);
  }

  Future<void> removeMealEntry(String id) async {
    final entries = await _getAllMeals();
    entries.removeWhere((e) => e.id == id);
    await _saveAllMeals(entries);
  }

  Future<List<MealEntry>> getMealsForDate(DateTime date) async {
    final allEntries = await _getAllMeals();
    return allEntries.where((entry) {
      return entry.timestamp.year == date.year &&
          entry.timestamp.month == date.month &&
          entry.timestamp.day == date.day;
    }).toList();
  }

  Future<List<MealEntry>> getTodayMeals() async {
    return getMealsForDate(DateTime.now());
  }

  Future<Map<String, int>> getNutritionForDate(DateTime date) async {
    final meals = await getMealsForDate(date);

    int totalCalories = 0;
    int totalCarbs = 0;
    int totalProtein = 0;
    int totalFat = 0;

    for (final meal in meals) {
      totalCalories += meal.calories;
      totalCarbs += meal.carbs;
      totalProtein += meal.protein;
      totalFat += meal.fat;
    }

    return {
      'calories': totalCalories,
      'carbs': totalCarbs,
      'protein': totalProtein,
      'fat': totalFat,
    };
  }

  Future<Map<String, int>> getTodayNutrition() async {
    return getNutritionForDate(DateTime.now());
  }

  Future<void> setNutritionGoals({
    required int calorieGoal,
    required int carbsGoal,
    required int proteinGoal,
    required int fatGoal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNutritionGoals, jsonEncode({
      'calories': calorieGoal,
      'carbs': carbsGoal,
      'protein': proteinGoal,
      'fat': fatGoal,
    }));
  }

  Future<Map<String, int>> getNutritionGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyNutritionGoals);
    
    if (jsonString == null) {
      // Default goals
      return {
        'calories': 2145,
        'carbs': 268,
        'protein': 107,
        'fat': 71,
      };
    }
    
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return {
      'calories': json['calories'],
      'carbs': json['carbs'],
      'protein': json['protein'],
      'fat': json['fat'],
    };
  }

  List<MealTemplate> getMealsByCategory(String category) {
    return mealDatabase.where((meal) => meal.category == category).toList();
  }

  List<MealTemplate> searchMeals(String query) {
    final lowerQuery = query.toLowerCase();
    return mealDatabase.where((meal) {
      return meal.name.toLowerCase().contains(lowerQuery) ||
             meal.category.toLowerCase().contains(lowerQuery) ||
             meal.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}

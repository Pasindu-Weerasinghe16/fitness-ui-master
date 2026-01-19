import 'package:flutter/material.dart';

import 'package:fitness_flutter/services/nutrition_tracking_service.dart';

class AddMealEntrySheet extends StatefulWidget {
  const AddMealEntrySheet({
    super.key,
    required this.service,
    required this.initialDate,
    this.initialMealType,
  });

  final NutritionTrackingService service;
  final DateTime initialDate;
  final String? initialMealType;

  static Future<MealEntry?> show(
    BuildContext context, {
    required NutritionTrackingService service,
    required DateTime date,
    String? initialMealType,
  }) {
    return showModalBottomSheet<MealEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: AddMealEntrySheet(
            service: service,
            initialDate: date,
            initialMealType: initialMealType,
          ),
        );
      },
    );
  }

  @override
  State<AddMealEntrySheet> createState() => _AddMealEntrySheetState();
}

class _AddMealEntrySheetState extends State<AddMealEntrySheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _carbsController;
  late final TextEditingController _proteinController;
  late final TextEditingController _fatController;

  late String _mealType;
  bool _isSaving = false;

  static const _mealTypes = <String>[
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Drink',
  ];

  @override
  void initState() {
    super.initState();
    _mealType = _mealTypes.contains(widget.initialMealType)
        ? widget.initialMealType!
        : 'Lunch';

    _nameController = TextEditingController();
    _caloriesController = TextEditingController();
    _carbsController = TextEditingController();
    _proteinController = TextEditingController();
    _fatController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  int _parseInt(TextEditingController c, {required int fallback}) {
    final v = int.tryParse(c.text.trim());
    if (v == null || v < 0) return fallback;
    return v;
  }

  DateTime _buildTimestamp(DateTime day) {
    final now = DateTime.now();
    return DateTime(day.year, day.month, day.day, now.hour, now.minute, now.second);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final timestamp = _buildTimestamp(widget.initialDate);
      final id = '${timestamp.microsecondsSinceEpoch}_${_nameController.text.trim().hashCode}';

      final entry = MealEntry(
        id: id,
        name: _nameController.text.trim(),
        mealType: _mealType,
        calories: _parseInt(_caloriesController, fallback: 0),
        carbs: _parseInt(_carbsController, fallback: 0),
        protein: _parseInt(_proteinController, fallback: 0),
        fat: _parseInt(_fatController, fallback: 0),
        timestamp: timestamp,
        imagePath: 'assets/images/image001.jpg',
      );

      await widget.service.addMealEntry(entry);
      if (!mounted) return;
      Navigator.pop(context, entry);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not add meal. Please try again.')),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    InputDecoration decoration(String label, {String? hint}) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Create meal',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _mealType,
                    items: _mealTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: _isSaving ? null : (v) => setState(() => _mealType = v ?? _mealType),
                    decoration: decoration('Meal type'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: decoration('Meal name', hint: 'e.g. Chicken rice'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter a meal name';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _caloriesController,
                          keyboardType: TextInputType.number,
                          decoration: decoration('Calories', hint: '0'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _carbsController,
                          keyboardType: TextInputType.number,
                          decoration: decoration('Carbs (g)', hint: '0'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _proteinController,
                          keyboardType: TextInputType.number,
                          decoration: decoration('Protein (g)', hint: '0'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _fatController,
                          keyboardType: TextInputType.number,
                          decoration: decoration('Fat (g)', hint: '0'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: Text(
                        _isSaving ? 'Saving…' : 'Add meal',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
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
}

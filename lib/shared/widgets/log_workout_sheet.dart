import 'package:flutter/material.dart';

import 'package:fitness_flutter/services/workout_tracking_service.dart';

class LogWorkoutSheet extends StatefulWidget {
  const LogWorkoutSheet({
    super.key,
    required this.service,
    required this.initialDate,
  });

  final WorkoutTrackingService service;
  final DateTime initialDate;

  static Future<WorkoutCompletion?> show(
    BuildContext context, {
    required WorkoutTrackingService service,
    required DateTime date,
  }) {
    return showModalBottomSheet<WorkoutCompletion>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: LogWorkoutSheet(service: service, initialDate: date),
        );
      },
    );
  }

  @override
  State<LogWorkoutSheet> createState() => _LogWorkoutSheetState();
}

class _LogWorkoutSheetState extends State<LogWorkoutSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  late final TextEditingController _caloriesController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _durationController = TextEditingController();
    _caloriesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
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
      final completedAt = _buildTimestamp(widget.initialDate);
      final completion = WorkoutCompletion(
        workoutTitle: _titleController.text.trim(),
        completedAt: completedAt,
        caloriesBurned: _parseInt(_caloriesController, fallback: 0),
        durationMinutes: _parseInt(_durationController, fallback: 0),
      );

      await widget.service.saveWorkoutCompletion(completion);
      if (!mounted) return;
      Navigator.pop(context, completion);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not log workout. Please try again.')),
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
                    'Log workout',
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
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: decoration('Workout name', hint: 'e.g. HIIT Cardio'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter a workout name';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: decoration('Duration (min)', hint: '0'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _caloriesController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: decoration('Calories burned', hint: '0'),
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
                        _isSaving ? 'Saving…' : 'Save workout',
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

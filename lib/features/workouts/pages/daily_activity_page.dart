import 'package:flutter/material.dart';

class DailyActivityArgs {
  const DailyActivityArgs({
    required this.activeMinutes,
    required this.calories,
    required this.weeklyWorkouts,
    required this.currentStreak,
    required this.bestStreak,
  });

  final int activeMinutes;
  final int calories;
  final int weeklyWorkouts;
  final int currentStreak;
  final int bestStreak;
}

class DailyActivityPage extends StatelessWidget {
  const DailyActivityPage({
    super.key,
    required this.args,
  });

  final DailyActivityArgs args;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Daily Activity'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              'View your daily activity',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A quick snapshot of today\'s movement and progress towards your goals.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                height: 1.25,
              ),
            ),
            const SizedBox(height: 20),

            _heroSummary(theme, isDark),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    theme,
                    isDark: isDark,
                    icon: Icons.access_time,
                    iconColor: theme.colorScheme.secondary,
                    label: 'Active minutes',
                    value: '${args.activeMinutes}',
                    suffix: 'min',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    theme,
                    isDark: isDark,
                    icon: Icons.local_fire_department,
                    iconColor: const Color(0xFFEF4444),
                    label: 'Calories',
                    value: '${args.calories}',
                    suffix: 'cal',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    theme,
                    isDark: isDark,
                    icon: Icons.fitness_center,
                    iconColor: const Color(0xFF10B981),
                    label: 'Workouts',
                    value: '${args.weeklyWorkouts}',
                    suffix: 'this week',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    theme,
                    isDark: isDark,
                    icon: Icons.local_fire_department,
                    iconColor: theme.colorScheme.primary,
                    label: 'Streak',
                    value: '${args.currentStreak}',
                    suffix: 'days',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _streakCard(theme, isDark),

            const SizedBox(height: 24),

            _tipsCard(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _heroSummary(ThemeData theme, bool isDark) {
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE9ECF3);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.24 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(isDark ? 0.22 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.insights,
              color: theme.colorScheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s snapshot',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Keep going — small wins add up.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(
    ThemeData theme, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String suffix,
  }) {
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE9ECF3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(isDark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  suffix,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _streakCard(ThemeData theme, bool isDark) {
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE9ECF3);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(isDark ? 0.20 : 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Color(0xFFF59E0B),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout streak',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Current: ${args.currentStreak} days · Best: ${args.bestStreak} days',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipsCard(ThemeData theme, bool isDark) {
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE9ECF3);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested next step',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a short walk or a quick stretch session to boost your activity today.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.80),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

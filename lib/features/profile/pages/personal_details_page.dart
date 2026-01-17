import 'package:flutter/material.dart';

class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Personal Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF007AFF).withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pasindu Weerasinghe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fitness Enthusiast',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Basic Info Section
              _sectionTitle(theme, 'Basic Information'),
              const SizedBox(height: 12),
              _infoCard(
                theme,
                icon: Icons.cake_outlined,
                label: 'Age',
                value: '28 years',
              ),
              const SizedBox(height: 10),
              _infoCard(
                theme,
                icon: Icons.height,
                label: 'Height',
                value: '175 cm',
              ),
              const SizedBox(height: 10),
              _infoCard(
                theme,
                icon: Icons.monitor_weight_outlined,
                label: 'Current Weight',
                value: '72 kg',
              ),
              const SizedBox(height: 10),
              _infoCard(
                theme,
                icon: Icons.flag_outlined,
                label: 'Target Weight',
                value: '68 kg',
              ),

              const SizedBox(height: 24),

              // Fitness Goals Section
              _sectionTitle(theme, 'Fitness Goals'),
              const SizedBox(height: 12),
              _goalCard(
                theme,
                title: 'Primary Goal',
                value: 'Lean & Strong',
                icon: Icons.fitness_center,
                color: const Color(0xFF007AFF),
              ),
              const SizedBox(height: 10),
              _goalCard(
                theme,
                title: 'Activity Level',
                value: 'Moderately Active',
                icon: Icons.directions_run,
                color: const Color(0xFF5AC8FA),
              ),
              const SizedBox(height: 10),
              _goalCard(
                theme,
                title: 'Weekly Target',
                value: '5 workouts/week',
                icon: Icons.calendar_today,
                color: const Color(0xFFFF9500),
              ),

              const SizedBox(height: 24),

              // Current Progress Section
              _sectionTitle(theme, 'Current Progress'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _progressRow(
                      theme,
                      'This Week',
                      '4/5 workouts',
                      0.8,
                      const Color(0xFF007AFF),
                    ),
                    const SizedBox(height: 16),
                    _progressRow(
                      theme,
                      'Current Streak',
                      '6 days',
                      0.6,
                      const Color(0xFF5AC8FA),
                    ),
                    const SizedBox(height: 16),
                    _progressRow(
                      theme,
                      'Calories Today',
                      '410/600 kcal',
                      0.68,
                      const Color(0xFFFF9500),
                    ),
                    const SizedBox(height: 16),
                    _progressRow(
                      theme,
                      'Steps Today',
                      '6,200/10,000',
                      0.62,
                      const Color(0xFF34C759),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Body Measurements Section
              _sectionTitle(theme, 'Body Measurements'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _measurementRow(theme, 'Chest', '98 cm'),
                    const Divider(height: 24),
                    _measurementRow(theme, 'Waist', '82 cm'),
                    const Divider(height: 24),
                    _measurementRow(theme, 'Arms', '35 cm'),
                    const Divider(height: 24),
                    _measurementRow(theme, 'Thighs', '58 cm'),
                    const Divider(height: 24),
                    _measurementRow(theme, 'Body Fat %', '18%'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Edit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // TODO: Navigate to edit profile page
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Personal Details'),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _infoCard(ThemeData theme,
      {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF007AFF), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalCard(ThemeData theme,
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressRow(
      ThemeData theme, String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: const Color(0xFFF2F2F7),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _measurementRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

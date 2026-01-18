import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/services/user_profile_service.dart';

class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  String _formatNum(num? value) {
    if (value == null) return 'Not set';
    final asDouble = value.toDouble();
    if (asDouble % 1 == 0) return asDouble.toInt().toString();
    return asDouble.toStringAsFixed(1);
  }

  Future<void> _editDisplayName(BuildContext context, User user, UserProfile? profile) async {
    final controller = TextEditingController(
      text: (profile?.displayName?.trim().isNotEmpty ?? false)
          ? profile!.displayName!.trim()
          : (user.displayName?.trim() ?? ''),
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Name'),
          content: TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Display name',
              hintText: 'e.g. Pasindu',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != true) return;
    final name = controller.text.trim();
    if (name.isEmpty) return;

    try {
      // Save to Firestore profile
      await UserProfileService().save(uid: user.uid, displayName: name, email: user.email);
      // Also update FirebaseAuth profile so other screens using user.displayName get it.
      await user.updateDisplayName(name);
      await user.reload();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name updated')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name update failed. Please try again.')),
      );
    }
  }

  Future<void> _editHeightWeight(BuildContext context, User user, UserProfile? profile) async {
    final heightController = TextEditingController(
      text: profile?.heightCm?.toString(),
    );
    final weightController = TextEditingController(
      text: profile?.weightKg?.toString(),
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Measurements'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    num? parseNum(String text) {
      final trimmed = text.trim();
      if (trimmed.isEmpty) return null;
      return num.tryParse(trimmed);
    }

    final height = parseNum(heightController.text);
    final weight = parseNum(weightController.text);

    try {
      await UserProfileService().save(
        uid: user.uid,
        email: user.email,
        heightCm: height,
        weightKg: weight,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Personal Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text('Please sign in to view your details.'))
            : StreamBuilder<UserProfile?>(
                stream: UserProfileService().watch(user.uid),
                builder: (context, snapshot) {
                  final profile = snapshot.data;
                  final displayName = (profile?.displayName != null && profile!.displayName!.trim().isNotEmpty)
                      ? profile.displayName!.trim()
                      : ((user.displayName != null && user.displayName!.trim().isNotEmpty)
                          ? user.displayName!.trim()
                          : (user.email ?? 'User'));
                  return SingleChildScrollView(
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
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Name
              _sectionTitle(theme, 'Profile'),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _editDisplayName(context, user, profile),
                borderRadius: BorderRadius.circular(16),
                child: _infoCard(
                  theme,
                  icon: Icons.badge_outlined,
                  label: 'Name',
                  value: displayName,
                ),
              ),
              const SizedBox(height: 10),

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
                value: '${_formatNum(profile?.heightCm)} cm',
              ),
              const SizedBox(height: 10),
              _infoCard(
                theme,
                icon: Icons.monitor_weight_outlined,
                label: 'Current Weight',
                value: '${_formatNum(profile?.weightKg)} kg',
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
                    _editHeightWeight(context, user, profile);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Height & Weight'),
                ),
              ),

              const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
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

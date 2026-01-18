import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/features/workouts/models/exercise.dart';
import 'package:fitness_flutter/features/workouts/pages/activity_detail.dart';
import 'package:fitness_flutter/features/workouts/pages/workout_detail_page.dart';
import 'package:fitness_flutter/shared/widgets/circular_progress_card.dart';
import 'package:fitness_flutter/shared/widgets/stat_card.dart';

class Programs extends StatefulWidget {
  const Programs({super.key});

  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  String _selectedDifficulty = 'All';

  final List<Map<String, String>> _workouts = [
    // Beginner Workouts
    {
      'image': 'assets/images/image001.jpg',
      'title': 'Morning Stretch',
      'duration': '10 min',
      'calories': '45 kCal',
      'difficulty': 'Beginner',
    },
    {
      'image': 'assets/images/image002.jpg',
      'title': 'Light Cardio',
      'duration': '15 min',
      'calories': '95 kCal',
      'difficulty': 'Beginner',
    },
    {
      'image': 'assets/images/image003.jpg',
      'title': 'Basic Yoga Flow',
      'duration': '20 min',
      'calories': '80 kCal',
      'difficulty': 'Beginner',
    },
    {
      'image': 'assets/images/image004.jpg',
      'title': 'Walking Routine',
      'duration': '25 min',
      'calories': '120 kCal',
      'difficulty': 'Beginner',
    },
    // Intermediate Workouts
    {
      'image': 'assets/images/image005.jpg',
      'title': 'HIIT Cardio',
      'duration': '30 min',
      'calories': '280 kCal',
      'difficulty': 'Intermediate',
    },
    {
      'image': 'assets/images/image001.jpg',
      'title': 'Full Body Strength',
      'duration': '35 min',
      'calories': '320 kCal',
      'difficulty': 'Intermediate',
    },
    {
      'image': 'assets/images/image002.jpg',
      'title': 'Bicep & Tricep',
      'duration': '25 min',
      'calories': '210 kCal',
      'difficulty': 'Intermediate',
    },
    {
      'image': 'assets/images/image003.jpg',
      'title': 'Core Blast',
      'duration': '20 min',
      'calories': '180 kCal',
      'difficulty': 'Intermediate',
    },
    {
      'image': 'assets/images/image004.jpg',
      'title': 'Power Yoga',
      'duration': '40 min',
      'calories': '250 kCal',
      'difficulty': 'Intermediate',
    },
    {
      'image': 'assets/images/image005.jpg',
      'title': 'Boxing Fundamentals',
      'duration': '30 min',
      'calories': '300 kCal',
      'difficulty': 'Intermediate',
    },
    // Pro Workouts
    {
      'image': 'assets/images/image001.jpg',
      'title': 'Advanced HIIT',
      'duration': '45 min',
      'calories': '520 kCal',
      'difficulty': 'Pro',
    },
    {
      'image': 'assets/images/image002.jpg',
      'title': 'Heavy Lifting',
      'duration': '50 min',
      'calories': '450 kCal',
      'difficulty': 'Pro',
    },
    {
      'image': 'assets/images/image003.jpg',
      'title': 'CrossFit WOD',
      'duration': '55 min',
      'calories': '580 kCal',
      'difficulty': 'Pro',
    },
    {
      'image': 'assets/images/image004.jpg',
      'title': 'Marathon Training',
      'duration': '60 min',
      'calories': '650 kCal',
      'difficulty': 'Pro',
    },
    {
      'image': 'assets/images/image005.jpg',
      'title': 'Elite Athlete Circuit',
      'duration': '50 min',
      'calories': '600 kCal',
      'difficulty': 'Pro',
    },
    {
      'image': 'assets/images/image001.jpg',
      'title': 'Powerlifting Session',
      'duration': '65 min',
      'calories': '480 kCal',
      'difficulty': 'Pro',
    },
  ];

  List<Map<String, String>> get _filteredWorkouts {
    if (_selectedDifficulty == 'All') {
      return _workouts;
    }
    return _workouts.where((w) => w['difficulty'] == _selectedDifficulty).toList();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName.split(' ').first;
    }
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) {
      final atIndex = email.indexOf('@');
      return atIndex > 0 ? email.substring(0, atIndex) : email;
    }
    return 'There';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateTime.now().toString().substring(0, 10).replaceAll('-', ', '),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_getGreeting()}, ${_getUserName()}!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Steps Count Circular Progress
              CircularProgressCard(
                title: 'Steps count',
                current: 6320,
                goal: 12000,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 20),

              // Stats Row
              Row(
                children: const [
                  StatCard(
                    icon: Icons.directions_walk,
                    label: 'Distance',
                    value: '2.4 km',
                  ),
                  SizedBox(width: 12),
                  StatCard(
                    icon: Icons.local_fire_department,
                    label: 'Calories',
                    value: '708',
                  ),
                  SizedBox(width: 12),
                  StatCard(
                    icon: Icons.favorite_border,
                    label: 'Heart',
                    value: '190',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Daily Activity Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.secondary,
                      theme.colorScheme.secondary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.secondary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VIEW YOUR DAILY ACTIVITY',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'See how active your body has been today and how it aligns with your wellness goals',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Featured Workouts Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured workouts',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Difficulty Filter Chips
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _difficultyChip(context, 'All'),
                    const SizedBox(width: 8),
                    _difficultyChip(context, 'Beginner'),
                    const SizedBox(width: 8),
                    _difficultyChip(context, 'Intermediate'),
                    const SizedBox(width: 8),
                    _difficultyChip(context, 'Pro'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Workout Cards Horizontal Scroll
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filteredWorkouts.length,
                  itemBuilder: (context, index) {
                    final workout = _filteredWorkouts[index];
                    return _workoutCard(
                      context,
                      image: workout['image']!,
                      title: workout['title']!,
                      duration: workout['duration']!,
                      calories: workout['calories']!,
                      difficulty: workout['difficulty']!,
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // This Week Section
              Text(
                'This week',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _weekStat(
                      context,
                      icon: Icons.fitness_center,
                      label: 'Workouts',
                      value: '4/5 completed',
                      progress: 0.8,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    _weekStat(
                      context,
                      icon: Icons.local_fire_department,
                      label: 'Calories burned',
                      value: '2,840 kcal',
                      progress: 0.71,
                      color: const Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 16),
                    _weekStat(
                      context,
                      icon: Icons.access_time,
                      label: 'Active time',
                      value: '3h 42min',
                      progress: 0.65,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _difficultyChip(BuildContext context, String label) {
    final theme = Theme.of(context);
    final isSelected = _selectedDifficulty == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDifficulty = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
            width: isSelected ? 0 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return const Color(0xFF10B981); // Green
      case 'Intermediate':
        return const Color(0xFFF59E0B); // Orange
      case 'Pro':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  Widget _workoutCard(
    BuildContext context, {
    required String image,
    required String title,
    required String duration,
    required String calories,
    required String difficulty,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Use new workout detail page for all workouts
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutDetailPage(
              exercise: Exercise(
                image: image,
                title: title,
                time: duration,
                difficult: difficulty,
              ),
              tag: title,
            ),
          ),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(difficulty),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      difficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        calories,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weekStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

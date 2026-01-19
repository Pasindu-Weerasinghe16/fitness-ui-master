import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_flutter/features/articles/data/sample_articles.dart';
import 'package:fitness_flutter/features/articles/models/article.dart';
import 'package:fitness_flutter/features/workouts/models/exercise.dart';
import 'package:fitness_flutter/features/workouts/pages/activity_detail.dart';
import 'package:fitness_flutter/features/workouts/pages/workout_detail_page.dart';
import 'package:fitness_flutter/features/workouts/pages/workout_calendar_page.dart';
import 'package:fitness_flutter/shared/widgets/circular_progress_card.dart';
import 'package:fitness_flutter/shared/widgets/stat_card.dart';
import 'package:fitness_flutter/services/workout_tracking_service.dart';

class Programs extends StatefulWidget {
  const Programs({super.key});

  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  String _selectedDifficulty = 'All';
  final _trackingService = WorkoutTrackingService();
  
  // Stats
  int _currentStreak = 0;
  int _bestStreak = 0;
  int _weeklyWorkouts = 0;
  int _activeMinutes = 0;
  int _todayCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final currentStreak = await _trackingService.getCurrentStreak();
    final bestStreak = await _trackingService.getBestStreak();
    final weeklyWorkouts = await _trackingService.getWeeklyWorkoutCount();
    final activeMinutes = await _trackingService.getTodayActiveMinutes();
    final todayCalories = await _trackingService.getTodayCalories();
    if (!mounted) return;

    setState(() {
      _currentStreak = currentStreak;
      _bestStreak = bestStreak;
      _weeklyWorkouts = weeklyWorkouts;
      _activeMinutes = activeMinutes;
      _todayCalories = todayCalories;
    });
  }

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
    final articles = kSampleArticles;

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
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WorkoutCalendarPage(),
                            ),
                          ).then((_) => _loadStats());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Workout Streak Ring
              CircularProgressCard(
                title: 'Workout Streak',
                current: _currentStreak,
                goal: _bestStreak > _currentStreak ? _bestStreak : _currentStreak + 3,
                color: theme.colorScheme.primary,
                subtitle: 'Best: $_bestStreak days',
              ),

              const SizedBox(height: 20),

              // Stats Grid - 4 Metrics
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _metricCard(
                          theme,
                          icon: Icons.event_available,
                          label: 'Weekly Goal',
                          value: '$_weeklyWorkouts',
                          target: '/ 5',
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _metricCard(
                          theme,
                          icon: Icons.access_time,
                          label: 'Active Today',
                          value: '$_activeMinutes',
                          target: ' min',
                          color: theme.colorScheme.secondary,
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
                          icon: Icons.local_fire_department,
                          label: 'Calories',
                          value: '$_todayCalories',
                          target: ' cal',
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _metricCard(
                          theme,
                          icon: Icons.fitness_center,
                          label: 'Workouts',
                          value: '$_weeklyWorkouts',
                          target: ' this week',
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
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

              // Achievements & Badges Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Achievements',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View all',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 190,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _achievementBadge(
                      theme,
                      icon: '🔥',
                      title: '${_currentStreak} Day Streak',
                      description: 'Keep it going!',
                      isUnlocked: _currentStreak >= 1,
                      progress: _currentStreak >= 5 ? 1.0 : _currentStreak / 5,
                      nextLevel: _currentStreak >= 5 ? 'Achieved!' : '${5 - _currentStreak} days to 5-day streak',
                    ),
                    _achievementBadge(
                      theme,
                      icon: '💪',
                      title: 'First Workout',
                      description: 'You started!',
                      isUnlocked: _weeklyWorkouts >= 1,
                      progress: 1.0,
                      nextLevel: 'Unlocked',
                    ),
                    _achievementBadge(
                      theme,
                      icon: '🎯',
                      title: 'Week Warrior',
                      description: 'Complete 5 workouts',
                      isUnlocked: _weeklyWorkouts >= 5,
                      progress: _weeklyWorkouts / 5,
                      nextLevel: _weeklyWorkouts >= 5 ? 'Achieved!' : '${5 - _weeklyWorkouts} more this week',
                    ),
                    _achievementBadge(
                      theme,
                      icon: '⚡',
                      title: 'Calorie Crusher',
                      description: 'Burn 500 cal/day',
                      isUnlocked: _todayCalories >= 500,
                      progress: (_todayCalories / 500).clamp(0.0, 1.0),
                      nextLevel: _todayCalories >= 500 ? 'Achieved!' : '${500 - _todayCalories} cal to go',
                    ),
                    _achievementBadge(
                      theme,
                      icon: '⏱️',
                      title: 'Active 45',
                      description: '45 min active/day',
                      isUnlocked: _activeMinutes >= 45,
                      progress: (_activeMinutes / 45).clamp(0.0, 1.0),
                      nextLevel: _activeMinutes >= 45 ? 'Achieved!' : '${45 - _activeMinutes} min to go',
                    ),
                    _achievementBadge(
                      theme,
                      icon: '🏆',
                      title: 'Champion',
                      description: '30 day streak',
                      isUnlocked: _bestStreak >= 30,
                      progress: (_currentStreak / 30).clamp(0.0, 1.0),
                      nextLevel: _bestStreak >= 30 ? 'Legendary!' : '${30 - _currentStreak} days to go',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Fitness Articles Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fitness Tips & Articles',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/articles');
                    },
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

              const SizedBox(height: 12),

              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < (articles.length < 5 ? articles.length : 5); i++)
                      _articleCard(theme, article: articles[i], index: i),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _achievementBadge(
    ThemeData theme, {
    required String icon,
    required String title,
    required String description,
    required bool isUnlocked,
    required double progress,
    required String nextLevel,
  }) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isUnlocked
            ? LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isUnlocked ? null : theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: !isUnlocked
            ? Border.all(
                color: theme.dividerColor,
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isUnlocked
                ? theme.colorScheme.primary.withOpacity(0.3)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontSize: 32,
                  color: isUnlocked ? Colors.white : Colors.grey,
                ),
              ),
              if (isUnlocked)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isUnlocked ? Colors.white : theme.colorScheme.onSurface,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isUnlocked
                  ? Colors.white.withOpacity(0.9)
                  : theme.textTheme.bodySmall?.color,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (!isUnlocked) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              nextLevel,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 9,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else
            Text(
              nextLevel,
              style: TextStyle(
                fontSize: 9,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _articleCard(
    ThemeData theme, {
    required Article article,
    required int index,
  }) {
    final readMinutes = _estimateReadMinutes(article.content);
    final category = (article.category ?? '').trim().isEmpty
        ? 'Fitness'
        : article.category!.trim();

    return GestureDetector(
      onTap: () {
        context.push('/articles/$index');
      },
      child: Container(
        width: 280,
        height: 220,
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
                    article.image,
                    height: 112,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        article.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.8),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$readMinutes min read',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _estimateReadMinutes(String text) {
    final wordCount = text
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
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

  Widget _metricCard(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required String target,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2, left: 2),
                child: Text(
                  target,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

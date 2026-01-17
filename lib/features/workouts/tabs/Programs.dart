import 'package:fitness_flutter/features/workouts/models/exercise.dart';
import 'package:fitness_flutter/features/workouts/pages/activity_detail.dart';
import 'package:fitness_flutter/features/profile/pages/personal_details_page.dart';
import 'package:fitness_flutter/shared/widgets/circle_bedge.dart';
import 'package:fitness_flutter/shared/widgets/Header.dart';
import 'package:fitness_flutter/shared/widgets/Section.dart';
import 'package:fitness_flutter/shared/widgets/daily_tip.dart';
import 'package:fitness_flutter/shared/widgets/image_card_with_basic_footer.dart';
import 'package:fitness_flutter/shared/widgets/image_card_with_internal.dart';
import 'package:fitness_flutter/shared/widgets/main_card_programs.dart';
import 'package:fitness_flutter/shared/widgets/user_photo.dart';
import 'package:fitness_flutter/shared/widgets/user_tip.dart';

import 'package:flutter/material.dart';

class Programs extends StatelessWidget {
  const Programs({super.key});

  final List<Exercise> exercises = const [
    Exercise(
      image: 'assets/images/image001.jpg',
      title: 'Easy Start',
      time: '5 min',
      difficult: 'Low',
    ),
    Exercise(
      image: 'assets/images/image002.jpg',
      title: 'Medium Start',
      time: '10 min',
      difficult: 'Medium',
    ),
    Exercise(
      image: 'assets/images/image003.jpg',
      title: 'Pro Start',
      time: '25 min',
      difficult: 'High',
    ),
  ];

  List<Widget> generateList(BuildContext context) {
    List<Widget> list = [];
    int count = 0;
    exercises.forEach((exercise) {
      Widget element = Container(
        margin: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          child: ImageCardWithBasicFooter(
            exercise: exercise,
            tag: 'imageHeader$count',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ActivityDetail(
                    exercise: exercise,
                    tag: 'imageHeader$count',
                  );
                },
              ),
            );
          },
        ),
      );
      list.add(element);
      count++;
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Header('Workouts', rightSide: UserPhoto()),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalDetailsPage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF007AFF).withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Personal snapshot', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('Today: 42 min · 410 kcal', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.95))),
                            const SizedBox(height: 8),
                            Row(children: const [
                              Icon(Icons.timelapse, size: 18, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Streak: 6 days', style: TextStyle(color: Colors.white)),
                            ]),
                            const SizedBox(height: 4),
                            Row(children: const [
                              Icon(Icons.monitor_heart, size: 18, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Goal: Lean & strong', style: TextStyle(color: Colors.white)),
                            ]),
                          ],
                        ),
                      ),
                      const CircleBadge(
                        color: Colors.white,
                        title: 'Gold',
                        subtitle: 'Badge',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MainCardPrograms(),
              const SizedBox(height: 14),
              Section(
                title: 'Ready-made routines',
                horizontalList: generateList(context),
              ),
              Section(
                title: 'Custom builder',
                horizontalList: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // Navigate to custom workout builder
                      _showCustomWorkoutBuilder(context);
                    },
                    child: ImageCardWithInternal(
                      image: 'assets/images/image004.jpg',
                      title: 'Build your plan',
                      duration: 'Tailored',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to power & strength preset
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActivityDetail(
                            exercise: const Exercise(
                              image: 'assets/images/image003.jpg',
                              title: 'Power & strength',
                              time: '35 min',
                              difficult: 'High',
                            ),
                            tag: 'custom_power',
                          ),
                        ),
                      );
                    },
                    child: ImageCardWithInternal(
                      image: 'assets/images/image003.jpg',
                      title: 'Power & strength',
                      duration: '35 min',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Track today', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _pill(icon: Icons.local_fire_department, label: '410 kcal'),
                        _pill(icon: Icons.access_time, label: '42 min'),
                        _pill(icon: Icons.directions_walk, label: '6,200 steps'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _goalCard(
                            context,
                            title: 'Smart goal',
                            caption: '3 sessions left · reminders on',
                            icon: Icons.flag_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _goalCard(
                            context,
                            title: 'Daily challenge',
                            caption: '20 pushups · Badge ready',
                            icon: Icons.bolt_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Badges & rewards', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CircleBadge(color: Color(0xFF22D3EE), title: 'Daily', subtitle: 'Check-in'),
                        CircleBadge(color: Color(0xFFF59E0B), title: '5k', subtitle: 'Steps'),
                        CircleBadge(color: Color(0xFF10B981), title: 'Hydro', subtitle: 'Goal'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Coach tips', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Section(
                      title: 'Daily tips',
                      horizontalList: <Widget>[
                        UserTip(image: 'assets/images/image010.jpg', name: 'Coach A'),
                        UserTip(image: 'assets/images/image010.jpg', name: 'Coach B'),
                        UserTip(image: 'assets/images/image010.jpg', name: 'Coach C'),
                      ],
                    ),
                    Section(
                      horizontalList: <Widget>[
                        DailyTip(),
                        DailyTip(),
                        DailyTip(),
                      ],
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

  Widget _pill({required IconData icon, required String label}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF007AFF)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Color(0xFF1C1C1E), fontSize: 14)),
        ],
      ),
    );
  }

  void _showCustomWorkoutBuilder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: controller,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Build Your Workout',
                      style: Theme.of(context).textTheme.headlineSmall),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildWorkoutOption(
                context,
                'Full Body Workout',
                '45 min',
                'Medium',
                Icons.fitness_center,
              ),
              _buildWorkoutOption(
                context,
                'Upper Body Focus',
                '30 min',
                'High',
                Icons.accessibility_new,
              ),
              _buildWorkoutOption(
                context,
                'Cardio Blast',
                '20 min',
                'High',
                Icons.directions_run,
              ),
              _buildWorkoutOption(
                context,
                'Core Strength',
                '15 min',
                'Medium',
                Icons.self_improvement,
              ),
              _buildWorkoutOption(
                context,
                'Flexibility & Stretch',
                '25 min',
                'Low',
                Icons.spa,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutOption(BuildContext context, String title, String time,
      String difficulty, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActivityDetail(
                exercise: Exercise(
                  image: 'assets/images/image003.jpg',
                  title: title,
                  time: time,
                  difficult: difficulty,
                ),
                tag: 'custom_${title.toLowerCase().replaceAll(' ', '_')}',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: theme.textTheme.bodySmall?.color),
                        const SizedBox(width: 4),
                        Text(time, style: theme.textTheme.bodySmall),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(difficulty)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            difficulty,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getDifficultyColor(difficulty),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: theme.textTheme.bodySmall?.color),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'low':
        return const Color(0xFF10B981);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'high':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _goalCard(BuildContext context,
      {required String title, required String caption, required IconData icon}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(caption, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


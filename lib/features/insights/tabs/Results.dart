import 'package:flutter/material.dart';

import 'package:fitness_flutter/shared/widgets/Header.dart';
import 'package:fitness_flutter/shared/widgets/circle_bedge.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';

class Results extends StatelessWidget {
  const Results({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Header('Results'),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 18.0),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16.0),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Insights overview',
                            style: theme.textTheme.titleMedium,
                          ),
                          Icon(Icons.camera_alt, color: theme.colorScheme.primary),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _chip(theme, Icons.local_fire_department, 'Calories', '480 / 600'),
                          _chip(theme, Icons.fitness_center, 'Workouts', '4 this week'),
                          _chip(theme, Icons.monitor_weight, 'Body', '56 kg · trending ↓'),
                          _chip(theme, Icons.watch_later_outlined, 'Sleep', '7h 45m'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 25.0,
                  horizontal: 20.0,
                ),
                width: width,
                decoration: BoxDecoration(color: theme.cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Achivments',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        CircleBadge(
                          color: Color(0xFF22D3EE),
                          title: '1st',
                          subtitle: 'Workout',
                        ),
                        CircleBadge(
                          color: Color(0xFFF59E0B),
                          title: '1000',
                          subtitle: 'kCal',
                        ),
                        CircleBadge(
                          color: Color(0xFF10B981),
                          title: 'Streak',
                          subtitle: '7 days',
                        ),
                      ],
                    ),
                    Text(
                      'You\'ve burned',
                      style: theme.textTheme.bodySmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '480 kCal',
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            'Target 600 kCal',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    RoundedProgressBar(
                      height: 20.0,
                      style: RoundedProgressBarStyle(
                        borderWidth: 0,
                        widthShadow: 0,
                        colorProgress: theme.colorScheme.primary,
                        colorProgressDark: theme.colorScheme.secondary,
                      ),
                      margin: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 16.0,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      percent: 80.0,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 55.0,
                  left: 20.0,
                  right: 20.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Weight Progress',
                      style: theme.textTheme.titleMedium,
                    ),
                    Container(
                      height: 250.0,
                      width: width - 40.0,
                      margin: const EdgeInsets.only(bottom: 30.0),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Center(
                        child: Text(
                          'Weight progress chart coming soon',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 110.0,
                            margin: const EdgeInsets.only(right: 12.0),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Weight',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    Text(
                                      '56 Kg',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Gained',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    Text(
                                      '13 Kg',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 110.0,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Goal',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  'Add +',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 45.0,
                        horizontal: 30.0,
                      ),
                      child: Text(
                        'Track your weight every morning before your breakfast',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(25.0),
                      width: width - 40.0,
                      margin: EdgeInsets.only(bottom: 30.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(241, 227, 255, 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Enter today\'s weight',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(190, 130, 255, 1.0),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _chip(ThemeData theme, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(value, style: theme.textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}


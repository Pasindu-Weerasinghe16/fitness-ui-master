import 'package:flutter/material.dart';

import 'package:fitness_flutter/features/insights/tabs/Results.dart';
import 'package:fitness_flutter/features/nutrition/tabs/Diet.dart';
import 'package:fitness_flutter/features/workouts/tabs/Programs_new.dart';
import 'package:fitness_flutter/features/account/pages/account_page.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: TabBarView(
          children: <Widget>[
            Programs(),
            Diet(),
            Results(),
            AccountPage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      tabs: const <Widget>[
                        Tab(
                          icon: Icon(Icons.fitness_center, size: 22),
                          iconMargin: EdgeInsets.only(bottom: 2),
                          text: 'Workouts',
                        ),
                        Tab(
                          icon: Icon(Icons.restaurant_menu, size: 22),
                          iconMargin: EdgeInsets.only(bottom: 2),
                          text: 'Nutrition',
                        ),
                        Tab(
                          icon: Icon(Icons.insights, size: 22),
                          iconMargin: EdgeInsets.only(bottom: 2),
                          text: 'Insights',
                        ),
                        Tab(
                          icon: Icon(Icons.person_outline, size: 22),
                          iconMargin: EdgeInsets.only(bottom: 2),
                          text: 'Account',
                        ),
                      ],
                      labelPadding: const EdgeInsets.symmetric(vertical: 4),
                      labelColor: Colors.white,
                      unselectedLabelColor: theme.colorScheme.onBackground.withOpacity(0.6),
                      labelStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      dividerColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

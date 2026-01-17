import 'package:flutter/material.dart';

import 'package:fitness_flutter/shared/widgets/Header.dart';
import 'package:fitness_flutter/shared/widgets/tab_view_base.dart';

class Diet extends StatelessWidget {
  const Diet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              flexibleSpace: Header(
                'Nutrition',
                rightSide: Container(
                  height: 38.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  margin: const EdgeInsets.only(right: 20.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Macro tracker',
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                tabs: <Widget>[
                  Container(height: 30.0, child: const Tab(text: 'Breakfast')),
                  Container(height: 30.0, child: const Tab(text: 'Lunch')),
                  Container(height: 30.0, child: const Tab(text: 'Dinner')),
                  Container(height: 30.0, child: const Tab(text: 'Snacks')),
                ],
                labelColor: isDark ? theme.colorScheme.primary : Colors.black,
                unselectedLabelColor: isDark ? Colors.white54 : Colors.black54,
                indicatorWeight: 4.0,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: theme.colorScheme.primary,
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                TabViewBase(tabName: 'Breakfast'),
                TabViewBase(tabName: 'Lunch'),
                TabViewBase(tabName: 'Dinner'),
                TabViewBase(tabName: 'Snacks'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


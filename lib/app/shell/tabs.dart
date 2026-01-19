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
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Builder(
              builder: (context) {
                final controller = DefaultTabController.of(context);
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return _PillBottomNav(
                      currentIndex: controller.index,
                      onSelect: (i) => controller.animateTo(i),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PillBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const _PillBottomNav({
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final barColor = theme.brightness == Brightness.dark
        ? const Color(0xFF0F0F10)
        : const Color(0xFF141416);

    final selectedBg = Colors.white.withOpacity(0.14);
    final selectedFg = Colors.white;
    final unselectedFg = Colors.white.withOpacity(0.62);

    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _PillNavItem(
            isSelected: currentIndex == 0,
            label: 'Home',
            icon: Icons.home_outlined,
            selectedBackground: selectedBg,
            selectedColor: selectedFg,
            unselectedColor: unselectedFg,
            onTap: () => onSelect(0),
          ),
          _PillNavItem(
            isSelected: currentIndex == 1,
            label: 'Meals',
            icon: Icons.receipt_long_outlined,
            selectedBackground: selectedBg,
            selectedColor: selectedFg,
            unselectedColor: unselectedFg,
            onTap: () => onSelect(1),
          ),
          _PillNavItem(
            isSelected: currentIndex == 2,
            label: 'Insights',
            icon: Icons.auto_awesome_outlined,
            selectedBackground: selectedBg,
            selectedColor: selectedFg,
            unselectedColor: unselectedFg,
            onTap: () => onSelect(2),
          ),
          _PillNavItem(
            isSelected: currentIndex == 3,
            label: 'Account',
            icon: Icons.person_outline,
            selectedBackground: selectedBg,
            selectedColor: selectedFg,
            unselectedColor: unselectedFg,
            onTap: () => onSelect(3),
          ),
        ],
      ),
    );
  }
}

class _PillNavItem extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData icon;
  final Color selectedBackground;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _PillNavItem({
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.selectedBackground,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 14 : 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedBackground : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisAlignment:
                isSelected ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              if (isSelected) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: selectedColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

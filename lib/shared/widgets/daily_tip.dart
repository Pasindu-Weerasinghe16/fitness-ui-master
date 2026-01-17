import 'package:flutter/material.dart';

class DailyTip extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final String content;
  final VoidCallback? onTap;

  const DailyTip({
    super.key,
    this.title = '3 Main workout tips',
    this.subtitle =
        'The American Council on Exercise (ACE) recently surveyed 3,000 certified personal trainers about what works best.',
    this.image = 'assets/images/image011.jpg',
    this.content =
        'Start with consistency. Pick a realistic schedule you can repeat each week.\n\nFocus on form over speed. Quality reps reduce injury risk and build strength faster.\n\nProgress gradually. Add a little time, weight, or intensity week to week.\n\nRecover well. Sleep, hydration, and light mobility work make training sustainable.',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.80;
    final theme = Theme.of(context);
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: width,
            height: 200.0,
            margin: const EdgeInsets.only(
              right: 15.0,
              bottom: 10.0,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 14.0),
          ),
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 10.0),
            child: Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 15.0,
            ),
            child: const Text(
              'Read',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

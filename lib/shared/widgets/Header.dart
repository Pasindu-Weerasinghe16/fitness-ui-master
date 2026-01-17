import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final Widget? rightSide;

  const Header(this.title, {super.key, this.rightSide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(
            title,
            style: theme.textTheme.headlineMedium,
          ),
          margin: const EdgeInsets.only(left: 20.0),
          height: 54.0,
        ),
        rightSide ?? const SizedBox.shrink(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fitness_flutter/app/shell/tabs.dart';
import 'package:fitness_flutter/app/theme/app_theme.dart';
import 'package:fitness_flutter/app/theme/theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const Scaffold(
            body: Tabs(),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:fitness_flutter/app/shell/tabs.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // iOS-inspired color palette
    const primary = Color(0xFF007AFF); // iOS Blue
    const secondary = Color(0xFF5AC8FA); // iOS Light Blue
    const accent = Color(0xFFFF9500); // iOS Orange
    const background = Color(0xFFF2F2F7); // iOS Light Background
    const cardColor = Color(0xFFFFFFFF); // Pure White Cards
    const surfaceColor = Color(0xFFFAFAFA); // Light Surface

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Geometria',
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: secondary,
          tertiary: accent,
          background: background,
          surface: cardColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: const Color(0xFF1C1C1E),
          onSurface: const Color(0xFF1C1C1E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          foregroundColor: Color(0xFF1C1C1E),
          titleTextStyle: TextStyle(
            fontFamily: 'Geometria',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1C1E),
            letterSpacing: 0.4,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
          ),
          titleMedium: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
          ),
          bodyLarge: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1C1C1E),
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3C3C43),
          ),
          bodySmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8E8E93),
          ),
          labelLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF007AFF),
          ),
        ),
        cardTheme: CardThemeData(
          color: cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.black.withOpacity(0.05),
        ),
        cardColor: cardColor,
        dividerColor: const Color(0xFFE5E5EA),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF007AFF),
          size: 24,
        ),
      ),
      home: const Scaffold(
        body: Tabs(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const _lightPrimary = Color(0xFF007AFF);
  static const _lightSecondary = Color(0xFF5AC8FA);
  static const _lightAccent = Color(0xFFFF9500);
  static const _lightBackground = Color(0xFFF2F2F7);
  static const _lightCardColor = Color(0xFFFFFFFF);
  static const _lightTextPrimary = Color(0xFF1C1C1E);
  static const _lightTextSecondary = Color(0xFF3C3C43);
  static const _lightTextTertiary = Color(0xFF8E8E93);

  // Dark Theme Colors
  static const _darkPrimary = Color(0xFF0A84FF);
  static const _darkSecondary = Color(0xFF64D2FF);
  static const _darkAccent = Color(0xFFFF9F0A);
  static const _darkBackground = Color(0xFF000000);
  static const _darkCardColor = Color(0xFF1C1C1E);
  static const _darkTextPrimary = Color(0xFFFFFFFF);
  static const _darkTextSecondary = Color(0xFFAEAEB2);
  static const _darkTextTertiary = Color(0xFF636366);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Geometria',
      fontFamilyFallback: const ['-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Arial'],
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackground,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        tertiary: _lightAccent,
        background: _lightBackground,
        surface: _lightCardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: _lightTextPrimary,
        onSurface: _lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        elevation: 0,
        centerTitle: true,
        foregroundColor: _lightTextPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'Geometria',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: _lightTextPrimary,
          letterSpacing: 0.4,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: _lightTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: _lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: _lightTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: _lightTextTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _lightPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      cardColor: _lightCardColor,
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
        color: _lightPrimary,
        size: 24,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Geometria',
      fontFamilyFallback: const ['-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Arial'],
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        tertiary: _darkAccent,
        background: _darkBackground,
        surface: _darkCardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: _darkTextPrimary,
        onSurface: _darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        elevation: 0,
        centerTitle: true,
        foregroundColor: _darkTextPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'Geometria',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: _darkTextPrimary,
          letterSpacing: 0.4,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: _darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: _darkTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: _darkTextTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _darkPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.white.withOpacity(0.05),
      ),
      cardColor: _darkCardColor,
      dividerColor: const Color(0xFF38383A),
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
        color: _darkPrimary,
        size: 24,
      ),
    );
  }
}

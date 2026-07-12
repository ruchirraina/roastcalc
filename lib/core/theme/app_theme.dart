import 'package:flutter/material.dart';

class AppTheme {
  // Light Mode Colors
  static const Color _lightBackground = Color(0xFFF0ECE1);
  static const Color _lightDigits = Color(0xFF4A4A4A);
  static const Color _lightOperators = Color(0xFFC26E60);
  static const Color _lightUtilities = Color(0xFF8A8A8A);
  static const Color _lightEquals = Color(0xFFDDA77B);
  static const Color _lightText = Color(0xFF111111);
  static const Color _lightButtonText = Color(0xFFF0ECE1);

  // Dark Mode Colors
  static const Color _darkBackground = Color(0xFF1E1E1E);
  static const Color _darkDigits = Color(0xFF3A3A3C);
  static const Color _darkOperators = Color(0xFFD47A6A);
  static const Color _darkUtilities = Color(0xFF5A5A5C);
  static const Color _darkEquals = Color(0xFFC68E58);
  static const Color _darkText = Color(0xFFEEEEEE);
  static const Color _darkButtonText = Color(0xFFEEEEEE);

  // Typography
  static const String _retroFont = 'SpaceMono';
  static const double _defaultFontSize = 16.0;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackground,
      fontFamily: _retroFont,
      colorScheme: const ColorScheme.light(
        primary: _lightDigits,
        onPrimary: _lightButtonText,
        secondary: _lightOperators,
        onSecondary: _lightButtonText,
        tertiary: _lightUtilities,
        onTertiary: _lightButtonText,
        primaryContainer: _lightEquals,
        onPrimaryContainer: _lightText,
        surface: _lightBackground,
        onSurface: _lightText,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: _lightText, fontSize: _defaultFontSize),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackground,
      fontFamily: _retroFont,
      colorScheme: const ColorScheme.dark(
        primary: _darkDigits,
        onPrimary: _darkButtonText,
        secondary: _darkOperators,
        onSecondary: Color(0xFF1E1E1E), // Dark text on operators for contrast
        tertiary: _darkUtilities,
        onTertiary: _darkButtonText,
        primaryContainer: _darkEquals,
        onPrimaryContainer: Color(0xFF111111), // Dark text on mustard
        surface: _darkBackground,
        onSurface: _darkText,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: _darkText, fontSize: _defaultFontSize),
      ),
    );
  }
}

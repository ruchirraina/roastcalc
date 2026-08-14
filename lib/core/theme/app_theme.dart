import 'package:flutter/material.dart';

class AppTheme {
  // Light Mode Colors
  static const Color _lightBackground = Color(0xFFF5F5DC); // Beige
  static const Color _lightPrimary = Color(0xFF333333); // Dark Gray
  static const Color _lightAccent = Color(0xFFFF4500); // Orange Red
  static const Color _lightText = Color(0xFF111111);

  // Dark Mode Colors
  static const Color _darkBackground = Color(0xFF121212); // Deep Charcoal
  static const Color _darkPrimary = Color(0xFF4CAF50); // Terminal Green
  static const Color _darkAccent = Color(0xFFFF9800); // Amber
  static const Color _darkText = Color(0xFFEEEEEE);

  // Typography
  static const String _retroFont = 'SpaceMono';
  static const double _defaultFontSize = 16.0;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackground,
      primaryColor: _lightPrimary,
      fontFamily: _retroFont,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightAccent,
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
      primaryColor: _darkPrimary,
      fontFamily: _retroFont,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkAccent,
        surface: _darkBackground,
        onSurface: _darkText,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: _darkText, fontSize: _defaultFontSize),
      ),
    );
  }
}

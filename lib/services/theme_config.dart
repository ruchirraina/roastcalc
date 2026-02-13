import 'package:flutter/material.dart';

// color for material seeding based color scheming
const Color _appColor = Colors.deepPurple;

// returns themeConfig for both light theme and dark theme
ThemeData themeConfig(Brightness brightness) {
  // color scheme create so we can use its colors
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _appColor,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'JetBrainsMono',
    colorScheme: colorScheme,

    appBarTheme: AppBarTheme(
      // explicit background is exactly the surface color
      backgroundColor: colorScheme.surface,

      // don't the color change on scroll
      surfaceTintColor: Colors.transparent,

      // mp shadow on scroll
      scrolledUnderElevation: 0,

      // ensure icons/text look correct
      foregroundColor: colorScheme.onSurface,
    ),

    // explicit Scaffold background matches
    scaffoldBackgroundColor: colorScheme.surface,
  );
}

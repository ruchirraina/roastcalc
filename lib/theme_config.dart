import 'package:flutter/material.dart';

// color for material seeding based color scheming
final Color _appColor = Colors.deepPurple;

// returns themeConfig for both light theme and dark theme
ThemeData themeConfig(Brightness brightness) {
  return ThemeData(
    colorScheme: .fromSeed(seedColor: _appColor, brightness: brightness),
  );
}

// lib/main.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/calculator_page.dart';

void main() {
  runApp(const RoastCalcApp());
}

class RoastCalcApp extends StatelessWidget {
  const RoastCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoastCalc',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const CalculatorPage(),
    );
  }
}

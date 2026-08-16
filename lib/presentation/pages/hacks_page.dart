import 'package:flutter/material.dart';
import '../../core/constants/calculator_constants.dart';

class HacksPage extends StatelessWidget {
  const HacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Math Hacks',
          style: textTheme.bodyMedium?.copyWith(
            fontSize: CalculatorConstants.fontMediumSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Loading Hacks...',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.tertiary),
        ),
      ),
    );
  }
}

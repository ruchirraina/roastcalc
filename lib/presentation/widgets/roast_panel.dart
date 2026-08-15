import 'package:flutter/material.dart';
import '../../core/constants/calculator_constants.dart';

class RoastPanel extends StatelessWidget {
  final String currentRoast;

  const RoastPanel({super.key, required this.currentRoast});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: CalculatorConstants.gridPadding,
        vertical: CalculatorConstants.gridPadding / 2,
      ),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.primary,
          width: CalculatorConstants.borderWidth,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department_outlined,
            color: colorScheme.primaryContainer,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
              switchOutCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Container(
                key: ValueKey(currentRoast),
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  child: Text(
                    currentRoast,
                    textAlign: TextAlign.left,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14.0,
                      color: colorScheme.onSurface,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

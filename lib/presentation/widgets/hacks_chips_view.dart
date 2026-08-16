import 'package:flutter/material.dart';
import '../../core/constants/calculator_constants.dart';

class HacksChipsView extends StatelessWidget {
  final List<String> chips;
  final ValueChanged<String> onChipSelected;

  const HacksChipsView({
    super.key,
    required this.chips,
    required this.onChipSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CalculatorConstants.gridPadding * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "What would you like to explore?",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32.0),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              runSpacing: 12.0,
              children: chips
                  .map(
                    (chip) => ActionChip(
                      label: Text(
                        chip,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 14.0,
                        ),
                      ),
                      backgroundColor: colorScheme.primaryContainer,
                      onPressed: () => onChipSelected(chip),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

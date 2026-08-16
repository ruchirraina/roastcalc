import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import '../../core/constants/calculator_constants.dart';

class HistoryPanel extends StatelessWidget {
  final CalculatorController controller;

  const HistoryPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(CalculatorConstants.borderRadius),
        border: Border.all(
          color: colorScheme.primary,
          width: CalculatorConstants.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.15),
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: CalculatorConstants.animSlow,
              child: controller.history.isEmpty
                  ? Center(
                      key: const ValueKey('empty'),
                      child: Text(
                        'No entries yet.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.tertiary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      key: const ValueKey('list'),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: controller.history.length,
                      separatorBuilder: (context, index) => Divider(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        height: 16,
                      ),
                      itemBuilder: (context, index) {
                        final entry = controller.history[index];
                        return InkWell(
                          onTap: () =>
                              controller.pasteFromHistory(entry.answer),
                          borderRadius: BorderRadius.circular(
                            CalculatorConstants.borderRadiusSmall,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  entry.expression,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.tertiary,
                                    fontSize: CalculatorConstants.fontSmall,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '= ${entry.answer}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: CalculatorConstants.fontMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          AnimatedSize(
            duration: CalculatorConstants.animPanel,
            curve: Curves.easeInOutCubic,
            child: controller.history.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: CalculatorConstants.borderWidth,
                        color: colorScheme.primary,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextButton(
                          onPressed: controller.clearHistory,
                          child: Text(
                            'CLEAR ALL',
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

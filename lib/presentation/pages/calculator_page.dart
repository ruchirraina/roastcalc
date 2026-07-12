import 'package:flutter/material.dart';
import '../../domain/calculator_service.dart';
import '../../core/constants/calculator_constants.dart';
import '../controllers/calculator_controller.dart';
import '../widgets/calculator_button.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late final CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalculatorController(CalculatorService());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Dart 3 Pattern Matching using the correct Logical-OR (||) operator
  Color _getBackgroundColor(String label, ColorScheme scheme) =>
      switch (label) {
        '÷' ||
        '×' ||
        '-' ||
        '+' ||
        '%' ||
        '!' ||
        '^' ||
        '√x' ||
        '³√x' ||
        '(' ||
        ')' ||
        'x²' ||
        'x³' => scheme.secondary,
        'AC' || '⌫' || 'EXP' => scheme.tertiary,
        '=' => scheme.primaryContainer,
        _ => scheme.primary,
      };

  Color _getTextColor(String label, ColorScheme scheme) => switch (label) {
    '÷' ||
    '×' ||
    '-' ||
    '+' ||
    '%' ||
    '!' ||
    '^' ||
    '√x' ||
    '³√x' ||
    '(' ||
    ')' ||
    'x²' ||
    'x³' => scheme.onSecondary,
    'AC' || '⌫' || 'EXP' => scheme.onTertiary,
    '=' => scheme.onPrimaryContainer,
    _ => scheme.onPrimary,
  };

  double _getFontSize(String label) => switch (label) {
    '÷' || '×' || '-' || '+' || '=' => CalculatorConstants.fontLarge,
    '^' => CalculatorConstants.fontMediumLarge,
    '(' || ')' => CalculatorConstants.fontMediumSmall,
    'x²' || 'x³' || '√x' || '³√x' => CalculatorConstants.fontTiny,
    'AC' || '⌫' => CalculatorConstants.fontSmall,
    'EXP' => CalculatorConstants.fontSmaller,
    _ => CalculatorConstants.fontMedium,
  };

  FontWeight _getFontWeight(String label) => switch (label) {
    'x²' || 'x³' || '√x' || '³√x' || 'AC' || '⌫' => FontWeight.bold,
    _ => FontWeight.normal,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              children: [
                // Display Area
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CalculatorConstants.gridPadding * 1.5,
                      vertical: CalculatorConstants.gridPadding / 2,
                    ),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: _controller.expressionController,
                          scrollController: _controller.scrollController,
                          readOnly: true,
                          showCursor: true,
                          autofocus: true,
                          cursorColor: colorScheme.primaryContainer,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: CalculatorConstants.fontHuge,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              _controller.answer,
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: CalculatorConstants.fontSmall,
                                color: colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Roast Area
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: CalculatorConstants.gridPadding,
                      vertical: CalculatorConstants.gridPadding / 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.primary,
                        width: CalculatorConstants.borderWidth,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(child: Text('Roast Area Placeholder')),
                  ),
                ),

                // Button Grid Area
                Expanded(
                  flex: 6,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final int activeRows = _controller.isExpanded
                          ? CalculatorConstants.expandedRows
                          : CalculatorConstants.standardRows;

                      final double availableWidth =
                          constraints.maxWidth -
                          (CalculatorConstants.gridPadding * 2) -
                          (CalculatorConstants.buttonSpacing *
                              (CalculatorConstants.maxColumns - 1));

                      final double availableHeight =
                          constraints.maxHeight -
                          (CalculatorConstants.gridPadding * 2) -
                          (CalculatorConstants.buttonSpacing *
                              (activeRows - 1));

                      final double buttonWidth =
                          availableWidth / CalculatorConstants.maxColumns;
                      final double buttonHeight = availableHeight / activeRows;

                      return Container(
                        padding: const EdgeInsets.all(
                          CalculatorConstants.gridPadding,
                        ),
                        child: Stack(
                          children: CalculatorConstants.layout.map((keyData) {
                            final int currentRow = _controller.isExpanded
                                ? keyData.row
                                : keyData.row - 2;

                            final bool isVisible =
                                _controller.isExpanded ||
                                !keyData.isExpandedOnly;

                            final double leftPos =
                                keyData.col *
                                (buttonWidth +
                                    CalculatorConstants.buttonSpacing);
                            final double topPos =
                                currentRow *
                                (buttonHeight +
                                    CalculatorConstants.buttonSpacing);

                            IconData? icon;
                            if (keyData.label == 'EXP') {
                              icon = _controller.isExpanded
                                  ? Icons.unfold_less
                                  : Icons.unfold_more;
                            }

                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOutBack,
                              left: leftPos,
                              top: topPos,
                              width: buttonWidth,
                              height: buttonHeight,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isVisible ? 1.0 : 0.0,
                                child: IgnorePointer(
                                  ignoring: !isVisible,
                                  child: CalculatorButton(
                                    label: keyData.label == 'EXP'
                                        ? null
                                        : keyData.label,
                                    icon: icon,
                                    backgroundColor: _getBackgroundColor(
                                      keyData.label,
                                      colorScheme,
                                    ),
                                    textColor: _getTextColor(
                                      keyData.label,
                                      colorScheme,
                                    ),
                                    fontSize: _getFontSize(keyData.label),
                                    fontWeight: _getFontWeight(keyData.label),
                                    onTap: () => _controller.handleButtonTap(
                                      keyData.label,
                                      keyData.value,
                                    ),
                                    onLongPress: keyData.label == '⌫'
                                        ? _controller.handleBackspaceLongPress
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

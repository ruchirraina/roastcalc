import 'package:flutter/material.dart';
import 'package:roastcalc/theme_extension.dart';

class ButtonGrid extends StatelessWidget {
  // box parameters that hold circular buttons with padding
  final double boxWidth;
  final double boxHeight;
  final double boxHeightShrink;

  // boolean value for history panel open
  final bool panelOpen;

  final void Function(String) onButtonPress;

  // recieving box parameters
  ButtonGrid({
    required this.boxWidth,
    required this.boxHeight,
    required this.boxHeightShrink,
    required this.panelOpen,
    required this.onButtonPress,
    super.key,
  });

  // all button labels
  final List<String> _buttonLabels = [
    'AC',
    'DEL',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '−',
    '1',
    '2',
    '3',
    '+',
    '00',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // static buttons that can fade out when history panel slides in
        // loop based generation and posiitoning of buttons
        for (int i = 0; i < 5; i++) // rows
          for (int j = 0; j < 3; j++) // columns
            // skipping 1st row and 2nd column (occupied by movable button)
            if (i != 0 || j != 1)
              Positioned(
                top: i * boxHeight,
                left: j * boxWidth,
                height: boxHeight,
                width: boxWidth,
                child: AnimatedOpacity(
                  // fade before history panel slides in
                  opacity: panelOpen ? 0 : 1,
                  // fade quick before history panel slides in
                  duration: const Duration(milliseconds: 100),
                  // linear curve simple
                  curve: Curves.linear,
                  child: Padding(
                    // padding around filled button
                    padding: const .all(4),
                    // AC button
                    child: (i == 0 && j == 0)
                        ? FilledButton(
                            style: FilledButton.styleFrom(
                              // circular
                              shape: const CircleBorder(),
                              backgroundColor:
                                  context.colorScheme.errorContainer, // red
                            ),
                            onPressed: () => onButtonPress(
                              _buttonLabels[0],
                            ), // non functional
                            child: Text(
                              _buttonLabels[0],
                              // appropriate style for AC button
                              style: context.textTheme.headlineMedium!.copyWith(
                                color: context.colorScheme.onErrorContainer,
                                fontWeight: .bold,
                              ),
                            ),
                          )
                        // % operator
                        : (i == 0 && j == 2)
                        ? FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              // circular
                              shape: const CircleBorder(),
                            ),
                            onPressed: () => onButtonPress(
                              _buttonLabels[2],
                            ), // non functional
                            child: Text(
                              _buttonLabels[2],
                              // appropriate style for % button
                              style: context.textTheme.headlineLarge!.copyWith(
                                fontWeight: .bold,
                              ),
                            ),
                          )
                        // numbers
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // circular
                              shape: const CircleBorder(),
                            ),
                            onPressed: () => onButtonPress(
                              _buttonLabels[4 * i + j],
                            ), // non functional
                            child: Text(
                              _buttonLabels[4 * i + j],
                              // appropriate style for numbers
                              style: context.textTheme.headlineLarge!.copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                  ),
                ),
              ),

        // operator buttons that shrink when history panel slides in
        Positioned(
          right: 0, // positioned on right
          child: Column(
            children: [
              // a dynamaic box to move the other buttons down when they shrink
              AnimatedContainer(
                // appropriate duration
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn, // appropriate curve
                // dynamic height - 0 when panel not present
                height: panelOpen ? boxHeightShrink : 0,
                width: boxWidth,
              ),
              // operator buttons
              // loop based generation and position of buttons
              for (int i = 0; i < 5; i++) // column
                AnimatedContainer(
                  // appropriate duration
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn, // appropriate curve
                  // dynamic height
                  height: panelOpen ? boxHeightShrink : boxHeight,
                  width: boxWidth,
                  child: Padding(
                    // padding around filled button
                    padding: const .all(4),
                    child: (i == 4)
                        // filled to emphasize equal to button
                        ? FilledButton(
                            // circular
                            style: FilledButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            onPressed: () {}, // non functional rn
                            child: Text(
                              _buttonLabels[19],
                              // appropriate size and style for =
                              style: context.textTheme.displaySmall!.copyWith(
                                color: context.colorScheme.onPrimary,
                                fontWeight: .bold,
                              ),
                            ),
                          )
                        // other operator buttons as tonal filled
                        : FilledButton.tonal(
                            // circular
                            style: FilledButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            onPressed: () => onButtonPress(
                              _buttonLabels[4 * (i + 1) - 1],
                            ), // non functional rn
                            child: Text(
                              _buttonLabels[4 * (i + 1) - 1],
                              // appropriate size and style for operators
                              style: context.textTheme.displayMedium!.copyWith(
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),

        // movable backspace button when history panel slides in
        AnimatedPositioned(
          top: 0, // in first row
          // first in 2nd column then slides to 4th column
          left: panelOpen ? 3 * boxWidth : boxWidth,
          duration: const Duration(milliseconds: 300), // appropriate duration
          curve: Curves.fastOutSlowIn, // appropriate curve
          // dynamic size - shrink to fit into 4th column
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300), // appropriate duration
            curve: Curves.fastOutSlowIn, // appropriate curve
            // shrink height
            height: panelOpen ? boxHeightShrink : boxHeight,
            width: boxWidth,
            child: Padding(
              // padding around filled button
              padding: const .all(4),
              child: FilledButton.tonal(
                // circular
                style: FilledButton.styleFrom(shape: const CircleBorder()),
                onPressed: () =>
                    onButtonPress(_buttonLabels[1]), // non functional rn
                child: const Icon(
                  Icons.backspace_outlined,
                  size: 32, // appropriate size
                  applyTextScaling: true, // so it doesn't look tiny if font big
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

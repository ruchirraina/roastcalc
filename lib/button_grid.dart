import 'package:flutter/material.dart';
import 'package:roastcalc/theme_extension.dart';

class ButtonGrid extends StatelessWidget {
  // box parameters that hold circular buttons with padding
  final double boxWidth;
  final double boxHeight;

  // recieving box parameters
  ButtonGrid({required this.boxWidth, required this.boxHeight, super.key});

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
    '3',
    '2',
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
        // movable backspace button when history panel slides in
        Positioned(
          top: 0,
          left: boxWidth,
          child: SizedBox(
            height: boxHeight,
            width: boxWidth,
            child: Padding(
              padding: .all(4),
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(shape: const CircleBorder()),
                onPressed: () {},
                child: Icon(
                  Icons.backspace_outlined,
                  size: 28,
                  applyTextScaling: true,
                ),
              ),
            ),
          ),
        ),

        // shrinking operator buttons that shrink when history panel slides in
        for (int i = 0; i < 5; i++)
          Positioned(
            top: i * boxHeight,
            right: 0,
            child: SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: Padding(
                padding: .all(4),
                child: (i == 4)
                    // to emphasize equal to button
                    ? FilledButton(
                        style: FilledButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        onPressed: () {},
                        child: Text(
                          _buttonLabels[19],
                          style: context.textTheme.displaySmall!.copyWith(
                            color: context.colorScheme.onPrimary,
                            fontWeight: .bold,
                          ),
                        ),
                      )
                    // other operator buttons
                    : FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        onPressed: () {},
                        child: Text(
                          _buttonLabels[4 * (i + 1) - 1],
                          style: context.textTheme.displaySmall!.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                      ),
              ),
            ),
          ),

        // static buttons that can fade out when history panel slides in
        for (int i = 0; i < 5; i++)
          for (int j = 0; j < 3; j++)
            if (i != 0 || j != 1)
              Positioned(
                top: i * boxHeight,
                left: j * boxWidth,
                child: SizedBox(
                  height: boxHeight,
                  width: boxWidth,
                  child: Padding(
                    padding: .all(4),
                    // AC and % button
                    child: (i == 0 && (j == 0 || j == 2))
                        ? FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            onPressed: () {},
                            child: Text(
                              _buttonLabels[j],
                              style:
                                  (j == 0) // for AC button
                                  ? context.textTheme.headlineSmall!.copyWith(
                                      fontWeight: .bold,
                                    )
                                  // for % button
                                  : context.textTheme.displaySmall!.copyWith(
                                      fontWeight: .bold,
                                    ),
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            onPressed: () {},
                            child: Text(
                              _buttonLabels[4 * i + j],
                              style: context.textTheme.headlineLarge!.copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
      ],
    );
  }
}

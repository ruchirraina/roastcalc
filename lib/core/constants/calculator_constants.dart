import '../../presentation/models/calculator_key.dart';

class CalculatorConstants {
  // Grid & Layout Constraints
  static const double gridPadding = 16.0;
  static const double buttonSpacing = 12.0;
  static const int maxColumns = 4;
  static const int standardRows = 5;
  static const int expandedRows = 7;
  static const double borderWidth = 2.0;

  // Typography Scaling
  static const double fontHuge = 48.0; // Main Expression
  static const double fontLarge = 36.0; // Standard Math Operators
  static const double fontMediumLarge = 32.0; // Caret (^)
  static const double fontMedium = 28.0; // Digits, %, !
  static const double fontMediumSmall = 26.0; // Parentheses
  static const double fontSmall = 24.0; // AC, Backspace, Answer Display
  static const double fontSmaller = 22.0; // EXP Button
  static const double fontTiny = 20.0; // Superscripts & Roots

  // Functional Constraints
  static const int maxExpressionLength = 50;

  // Static Button Configuration
  static const List<CalculatorKey> layout = [
    // Top Row (Expanded Only)
    CalculatorKey(label: '!', value: '!', col: 0, row: 0, isExpandedOnly: true),
    CalculatorKey(label: '^', value: '^', col: 1, row: 0, isExpandedOnly: true),
    CalculatorKey(
      label: '√x',
      value: '√',
      col: 2,
      row: 0,
      isExpandedOnly: true,
    ),
    CalculatorKey(
      label: '³√x',
      value: '³√',
      col: 3,
      row: 0,
      isExpandedOnly: true,
    ),

    // Second Row (Expanded Only)
    CalculatorKey(label: '(', value: '(', col: 0, row: 1, isExpandedOnly: true),
    CalculatorKey(label: ')', value: ')', col: 1, row: 1, isExpandedOnly: true),
    CalculatorKey(
      label: 'x²',
      value: '²',
      col: 2,
      row: 1,
      isExpandedOnly: true,
    ),
    CalculatorKey(
      label: 'x³',
      value: '³',
      col: 3,
      row: 1,
      isExpandedOnly: true,
    ),

    // Core Layout
    CalculatorKey(label: 'AC', value: 'AC', col: 0, row: 2),
    CalculatorKey(label: '⌫', value: '⌫', col: 1, row: 2),
    CalculatorKey(label: '%', value: '%', col: 2, row: 2),
    CalculatorKey(label: '÷', value: '÷', col: 3, row: 2),

    CalculatorKey(label: '7', value: '7', col: 0, row: 3),
    CalculatorKey(label: '8', value: '8', col: 1, row: 3),
    CalculatorKey(label: '9', value: '9', col: 2, row: 3),
    CalculatorKey(label: '×', value: '×', col: 3, row: 3),

    CalculatorKey(label: '4', value: '4', col: 0, row: 4),
    CalculatorKey(label: '5', value: '5', col: 1, row: 4),
    CalculatorKey(label: '6', value: '6', col: 2, row: 4),
    CalculatorKey(label: '-', value: '-', col: 3, row: 4),

    CalculatorKey(label: '1', value: '1', col: 0, row: 5),
    CalculatorKey(label: '2', value: '2', col: 1, row: 5),
    CalculatorKey(label: '3', value: '3', col: 2, row: 5),
    CalculatorKey(label: '+', value: '+', col: 3, row: 5),

    CalculatorKey(label: 'EXP', value: 'EXP', col: 0, row: 6),
    CalculatorKey(label: '0', value: '0', col: 1, row: 6),
    CalculatorKey(label: '.', value: '.', col: 2, row: 6),
    CalculatorKey(label: '=', value: '=', col: 3, row: 6),
  ];
}

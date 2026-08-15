import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  /// Evaluates a raw mathematical string and returns the calculated result.
  /// Returns null if the expression is invalid, incomplete, or a bare number.
  String? evaluateExpression(String expression) {
    if (expression.trim().isEmpty) return null;

    // Ignore single raw numbers
    if (double.tryParse(expression.trim()) != null) {
      return null;
    }

    try {
      String processed = expression;

      // Prepend zero to bare decimals
      processed = processed.replaceAllMapped(
        RegExp(r'(^|[-+*÷/×(]|\s)\.(\d+)'),
        (match) => '${match[1]}0.${match[2]}',
      );

      // Implicit Multiplication: Number before parenthesis (e.g., 3(2) -> 3*(2))
      processed = processed.replaceAllMapped(
        RegExp(r'(\d)\s*\('),
        (match) => '${match[1]}*(',
      );

      // Implicit Multiplication: Number after parenthesis (e.g., (1+1)2 -> (1+1)*2)
      processed = processed.replaceAllMapped(
        RegExp(r'\)\s*(\d|\.)'),
        (match) => ')*${match[1]}',
      );

      // Implicit Multiplication: Parentheses touching (e.g., (2)(3) -> (2)*(3))
      processed = processed.replaceAllMapped(
        RegExp(r'\)\s*\('),
        (match) => ')*(',
      );

      // Auto-wrap bare numbers after roots (e.g., √9 -> √(9), ³√8 -> ³√(8))
      processed = processed.replaceAllMapped(
        RegExp(r'(³?√)(\d+(\.\d+)?)'),
        (match) => '${match[1]}(${match[2]})',
      );

      // Translate basic visual UI symbols
      processed = processed.replaceAll('×', '*');
      processed = processed.replaceAll('÷', '/');

      // Translate multi-character visual root symbols FIRST
      processed = processed.replaceAll('³√', 'cbrt');
      processed = processed.replaceAll('√', 'sqrt');

      // Translate advanced visual superscripts SECOND
      processed = processed.replaceAll('²', '^2');
      processed = processed.replaceAll('³', '^3');

      // Handle percentage with implicit multiplication
      processed = processed.replaceAllMapped(
        RegExp(r'%\s*(?=[\d(.])'),
        (match) => ' / 100 * ',
      );
      processed = processed.replaceAll('%', ' / 100');

      // Handle programmatic square roots
      processed = processed.replaceAllMapped(
        RegExp(r'sqrt\(([^)]+)\)'),
        (match) => '((${match[1]}) ^ 0.5)',
      );

      // Handle programmatic cube roots
      processed = processed.replaceAllMapped(
        RegExp(r'cbrt\(([^)]+)\)'),
        (match) => '((${match[1]}) ^ (1 / 3))',
      );

      // 2. Parse and Evaluate
      final GrammarParser parser = GrammarParser();
      final Expression parsedExpression = parser.parse(processed);
      final ContextModel context = ContextModel();

      final RealEvaluator evaluator = RealEvaluator(context);
      final num result = evaluator.evaluate(parsedExpression);

      // Catch zero-division memory states
      if (result.isNaN || result.isInfinite) {
        return 'Undefined';
      }

      // 3. Prevent floating point calculation drift
      double roundedResult;
      if (result % 1 == 0) {
        roundedResult = result.toDouble();
      } else {
        const double precisionFactor = 10000000000.0;
        roundedResult =
            (result.toDouble() * precisionFactor).roundToDouble() /
            precisionFactor;
      }

      return _formatOutput(roundedResult);
    } catch (e) {
      return null;
    }
  }

  String _formatOutput(double value) {
    String resultString = value.toString();
    if (resultString.endsWith('.0')) {
      resultString = resultString.substring(0, resultString.length - 2);
    }
    return resultString;
  }
}

import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  /// Evaluates a raw mathematical string and returns the calculated result.
  /// Returns null if the expression is invalid, incomplete, or a bare number.
  String? evaluateExpression(String expression) {
    if (expression.trim().isEmpty) return null;

    try {
      // 1. Preprocess the raw string to handle visual layout tokens and library limitations.
      String processed = expression;

      // Translate basic visual UI symbols
      processed = processed.replaceAll('×', '*');
      processed = processed.replaceAll('÷', '/');

      // Translate multi-character visual root symbols FIRST to prevent superscript collision
      processed = processed.replaceAll('³√', 'cbrt');
      processed = processed.replaceAll('√', 'sqrt');

      // Translate advanced visual superscripts SECOND
      processed = processed.replaceAll('²', '^2');
      processed = processed.replaceAll('³', '^3');

      // Handle percentage as a unary suffix
      processed = processed.replaceAllMapped(
        RegExp(r'%(?!\s*[\d(])'),
        (match) => ' / 100',
      );

      // Handle custom mod keyword
      processed = processed.replaceAll('mod', '%');

      // Handle programmatic square roots
      processed = processed.replaceAllMapped(
        RegExp(r'sqrt\(([^)]+)\)'),
        (match) => '((${match[1]}) ^ 0.5)', // Added inner parentheses
      );

      // Handle programmatic cube roots
      processed = processed.replaceAllMapped(
        RegExp(r'cbrt\(([^)]+)\)'),
        (match) => '((${match[1]}) ^ (1 / 3))', // Added inner parentheses
      );

      // 2. Parse and Evaluate
      final GrammarParser parser = GrammarParser();
      final Expression parsedExpression = parser.parse(processed);
      final ContextModel context = ContextModel();

      final RealEvaluator evaluator = RealEvaluator(context);
      final num result = evaluator.evaluate(parsedExpression);

      // 3. Prevent floating point calculation drift
      const double precisionFactor = 10000000000.0;
      double roundedResult =
          (result.toDouble() * precisionFactor).roundToDouble() /
          precisionFactor;

      final String formattedResult = _formatOutput(roundedResult);

      // Ignore single raw numbers
      if (formattedResult == expression.trim()) {
        return null;
      }

      return formattedResult;
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

import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  /// Evaluates a raw mathematical string and returns the calculated result.
  /// Returns null if the expression is invalid, incomplete, or a bare number.
  String? evaluateExpression(String expression) {
    if (expression.trim().isEmpty) return null;

    try {
      final GrammarParser parser = GrammarParser();
      final Expression parsedExpression = parser.parse(expression);
      final ContextModel context = ContextModel();

      final RealEvaluator evaluator = RealEvaluator(context);
      final num result = evaluator.evaluate(parsedExpression);

      final String formattedResult = _formatOutput(result.toDouble());

      // Ignore single raw numbers as per the specification.
      if (formattedResult == expression.trim()) {
        return null;
      }

      return formattedResult;
    } catch (e) {
      // Catch syntax errors (e.g., "5 + ") and return null safely.
      return null;
    }
  }

  String _formatOutput(double value) {
    String resultString = value.toString();
    // Remove the decimal point for whole numbers.
    if (resultString.endsWith('.0')) {
      resultString = resultString.substring(0, resultString.length - 2);
    }
    return resultString;
  }
}

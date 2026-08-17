import 'package:math_expressions/math_expressions.dart';
import '../../core/constants/app_config.dart';

class CalculatorService {
  String? evaluateExpression(String expression) {
    if (expression.trim().isEmpty) return null;

    if (double.tryParse(expression.trim()) != null) {
      return null;
    }

    try {
      String processed = expression;

      processed = processed.replaceAllMapped(
        RegExp(r'(^|[-+*÷/×(]|\s)\.(\d+)'),
        (match) => '${match[1]}0.${match[2]}',
      );

      if (RegExp(r'\.\d*\s*!').hasMatch(processed)) {
        return 'Undefined';
      }

      processed = processed.replaceAllMapped(
        RegExp(r'(\d)\s*\('),
        (match) => '${match[1]}*(',
      );

      processed = processed.replaceAllMapped(
        RegExp(r'\)\s*(\d|\.)'),
        (match) => ')*${match[1]}',
      );

      processed = processed.replaceAllMapped(
        RegExp(r'\)\s*\('),
        (match) => ')*(',
      );

      // Uses the clean ∛ Unicode character
      processed = processed.replaceAllMapped(
        RegExp(r'(∛|√)(\d+(\.\d+)?)'),
        (match) => '${match[1]}(${match[2]})',
      );

      processed = processed.replaceAll('×', '*');
      processed = processed.replaceAll('÷', '/');
      processed = processed.replaceAll('∛', 'cbrt');
      processed = processed.replaceAll('√', 'sqrt');
      processed = processed.replaceAll('²', '^2');
      processed = processed.replaceAll('³', '^3');

      processed = processed.replaceAllMapped(
        RegExp(r'%\s*(?=[\d(.])'),
        (match) => ' / 100 * ',
      );
      processed = processed.replaceAll('%', ' / 100');

      processed = processed.replaceAllMapped(
        RegExp(r'sqrt\(([^)]+)\)'),
        (match) => '((${match[1]}) ^ 0.5)',
      );

      // Loop to safely resolve nested cube roots (e.g. ∛∛27) inside out
      for (int i = 0; i < 3; i++) {
        processed = processed.replaceAllMapped(
          RegExp(r'cbrt\(([^)]+)\)'),
          (match) => '((${match[1]}) ^ (1 / 3))',
        );
      }

      final GrammarParser parser = GrammarParser();
      final Expression parsedExpression = parser.parse(processed);
      final ContextModel context = ContextModel();

      final RealEvaluator evaluator = RealEvaluator(context);
      final num result = evaluator.evaluate(parsedExpression);

      if (result.isNaN || result.isInfinite) {
        return 'Undefined';
      }

      double roundedResult;
      if (result % 1 == 0) {
        roundedResult = result.toDouble();
      } else {
        roundedResult =
            (result.toDouble() * AppConfig.mathPrecisionFactor)
                .roundToDouble() /
            AppConfig.mathPrecisionFactor;
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

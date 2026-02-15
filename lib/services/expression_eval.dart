import 'package:math_expressions/math_expressions.dart';

// evaluate expression and return answer as string
String expressionEvaluator(String expression) {
  // sanitize expression - replace × with *, − with -, ÷ with /
  String sanitizedExpression = expression
      .replaceAll('×', '*')
      .replaceAll('−', '-')
      .replaceAll('÷', '/')
      .replaceAll('%', '*0.01*');

  final bool expressionEndsWithOperator =
      (sanitizedExpression.endsWith('+') ||
      sanitizedExpression.endsWith('-') ||
      sanitizedExpression.endsWith('*') ||
      sanitizedExpression.endsWith('/'));

  if (expressionEndsWithOperator) {
    sanitizedExpression = sanitizedExpression.substring(
      0,
      sanitizedExpression.length - 1,
    );
  }

  try {
    // create parser
    ExpressionParser parser = GrammarParser();

    // create parsed expression using parser
    Expression parsedExpression = parser.parse(sanitizedExpression);

    // create context model - not really needed but required by evaluator
    ContextModel cm = ContextModel();

    // create evaluator
    ExpressionEvaluator evaluator = RealEvaluator(cm);

    // evaluate expression and return result as string
    String result = evaluator.evaluate(parsedExpression).toString();

    if (result.contains('-')) {
      result = result.replaceAll('-', '−');
    }

    // if ends with .0 remove it
    if (result.endsWith('.0')) {
      result = result.substring(0, result.length - 2);
    } else if (result == 'NaN') {
      result = 'Indeterminate';
    }
    return result;
  } catch (e) {
    return '';
  }
}

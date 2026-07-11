import 'package:flutter_test/flutter_test.dart';
import 'package:roastcalc/domain/calculator_service.dart';

void main() {
  late CalculatorService calculator;

  setUp(() {
    calculator = CalculatorService();
  });

  group('CalculatorService - Core Arithmetic & Formatting', () {
    test('Evaluates standard operations with order of operations', () {
      expect(calculator.evaluateExpression('10 + 2 × 5 - 4 ÷ 2'), '18');
    });

    test('Trims decimal points cleanly for whole integers', () {
      expect(calculator.evaluateExpression('4.0 + 2.0'), '6');
    });

    test('Maintains precise floating point values for fractional results', () {
      expect(calculator.evaluateExpression('7 / 4'), '1.75');
    });
  });

  group('CalculatorService - Parentheses & Priority', () {
    test('Evaluates grouped expressions first', () {
      expect(calculator.evaluateExpression('(5 + 5) * 2'), '20');
    });

    test('Evaluates nested parentheses correctly', () {
      expect(calculator.evaluateExpression('2 * ((3 + 3) * 2)'), '24');
    });
  });

  group('CalculatorService - Specification Layout Toggles (Expanded Mode)', () {
    test('Evaluates percentage operator as division by 100', () {
      expect(calculator.evaluateExpression('50 %'), '0.5');
    });

    test('Evaluates modulo operation', () {
      expect(calculator.evaluateExpression('10 mod 3'), '1');
    });

    test('Evaluates reciprocal expressions', () {
      expect(calculator.evaluateExpression('1 / 4'), '0.25');
    });

    test('Evaluates visual powers (square, cube, general powers)', () {
      expect(calculator.evaluateExpression('5²'), '25');
      expect(calculator.evaluateExpression('2³'), '8');
      expect(calculator.evaluateExpression('2 ^ 5'), '32');
    });

    test('Evaluates visual roots (square root, cube root)', () {
      expect(calculator.evaluateExpression('√(16)'), '4');
      expect(calculator.evaluateExpression('³√(8)'), '2');
    });

    test('Evaluates factorial operator', () {
      expect(calculator.evaluateExpression('5!'), '120');
      expect(calculator.evaluateExpression('3!'), '6');
    });
  });

  group('CalculatorService - Edge Cases & Specification Restrictions', () {
    test('Strictly returns null for a single bare number', () {
      expect(calculator.evaluateExpression('150'), isNull);
      expect(calculator.evaluateExpression('9.99'), isNull);
    });

    test('Strictly returns null for incomplete syntax errors', () {
      expect(calculator.evaluateExpression('5 +'), isNull);
      expect(calculator.evaluateExpression('('), isNull);
      expect(calculator.evaluateExpression('5 * (2 +)'), isNull);
    });

    test('Strictly returns null for completely empty or whitespace inputs', () {
      expect(calculator.evaluateExpression(''), isNull);
      expect(calculator.evaluateExpression('    '), isNull);
    });
  });
}

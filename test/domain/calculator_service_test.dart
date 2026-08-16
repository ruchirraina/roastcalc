import 'package:flutter_test/flutter_test.dart';
import 'package:roastcalc/domain/services/calculator_service.dart';

void main() {
  late CalculatorService calculator;

  setUp(() {
    calculator = CalculatorService();
  });

  group('CalculatorService - Core Arithmetic & Formatting', () {
    test('Evaluates standard operations with order of operations', () {
      expect(calculator.evaluateExpression('10 + 2 * 5 - 4 / 2'), '18');
    });

    test('Trims decimal points cleanly for whole integers', () {
      expect(calculator.evaluateExpression('4.0 + 2.0'), '6');
    });
  });

  group('CalculatorService - Implicit Multiplication', () {
    test('Evaluates number directly before parenthesis', () {
      expect(calculator.evaluateExpression('3(2)'), '6');
      expect(calculator.evaluateExpression('3*(2)'), '6');
    });

    test('Evaluates number directly after parenthesis', () {
      expect(calculator.evaluateExpression('(1+1)2'), '4');
      expect(calculator.evaluateExpression('(1+1)*2'), '4');
    });

    test('Evaluates touching parentheses', () {
      expect(calculator.evaluateExpression('(2)(3)'), '6');
    });
  });

  group('CalculatorService - Specification Layout Toggles (Expanded Mode)', () {
    test('Evaluates percentage operator as division by 100', () {
      expect(calculator.evaluateExpression('50 %'), '0.5');
    });

    test('Evaluates explicit powers (general powers)', () {
      expect(calculator.evaluateExpression('5^2'), '25');
      expect(calculator.evaluateExpression('2^3'), '8');
      expect(calculator.evaluateExpression('2 ^ 5'), '32');
    });

    test('Evaluates text roots with bare numbers (auto-wrapping)', () {
      expect(calculator.evaluateExpression('sqrt9'), '3');
      expect(calculator.evaluateExpression('cbrt8'), '2');
    });

    test('Evaluates text roots with explicit parentheses', () {
      expect(calculator.evaluateExpression('sqrt(16)'), '4');
      expect(calculator.evaluateExpression('cbrt(27)'), '3');
    });

    test('Evaluates factorial operator', () {
      expect(calculator.evaluateExpression('5!'), '120');
      expect(calculator.evaluateExpression('3!'), '6');
    });
  });

  group('CalculatorService - Edge Cases & Specification Restrictions', () {
    test('Strictly returns null for a single bare number', () {
      expect(calculator.evaluateExpression('150'), isNull);
    });

    test('Strictly returns null for completely empty or whitespace inputs', () {
      expect(calculator.evaluateExpression(''), isNull);
      expect(calculator.evaluateExpression('    '), isNull);
    });

    test('Returns Undefined for decimal factorials', () {
      expect(calculator.evaluateExpression('2.5!'), 'Undefined');
      expect(calculator.evaluateExpression('.5!'), 'Undefined');
    });
  });
}

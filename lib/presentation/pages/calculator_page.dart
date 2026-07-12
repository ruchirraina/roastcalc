import 'package:flutter/material.dart';
import '../../domain/calculator_service.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorService _calculatorService = CalculatorService();
  String _expression = '';
  String _answer = '';

  void _updateExpression(String value) {
    setState(() {
      _expression += value;
      final result = _calculatorService.evaluateExpression(_expression);
      _answer = result ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display Area
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression.isEmpty ? '0' : _expression,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 48.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _answer,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 24.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Roast Area
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(child: Text('Roast Area Placeholder')),
              ),
            ),

            // Button Grid Area
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: const Center(child: Text('Button Grid Placeholder')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

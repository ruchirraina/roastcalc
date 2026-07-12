import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/calculator_service.dart';
import '../../core/constants/calculator_constants.dart';

class CalculatorController extends ChangeNotifier {
  final CalculatorService _calculatorService;

  final TextEditingController expressionController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String answer = '';
  bool isExpanded = false;

  CalculatorController(this._calculatorService);

  @override
  void dispose() {
    expressionController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void handleButtonTap(String label, String value) {
    if (label == '=' || label == 'AC') {
      HapticFeedback.vibrate();
    }

    if (label == 'AC') {
      _clearState();
    } else if (label == '⌫') {
      _handleBackspace();
    } else if (label == '=') {
      _handleEquals();
    } else if (label == 'EXP') {
      isExpanded = !isExpanded;
    } else {
      _handleInput(value);
    }

    if (label != 'EXP' && label != '=') {
      _evaluateCurrentExpression();
    }

    notifyListeners();
    _scrollToEnd();
  }

  void handleBackspaceLongPress() {
    HapticFeedback.vibrate();
    _clearState();
    notifyListeners();
  }

  void _clearState() {
    expressionController.clear();
    answer = '';
  }

  void _handleBackspace() {
    final text = expressionController.text;
    if (text.isEmpty) return;

    final selection = expressionController.selection;
    int cursorPos = selection.isValid ? selection.baseOffset : text.length;
    if (cursorPos == -1) cursorPos = text.length;

    if (cursorPos > 0) {
      final newText =
          text.substring(0, cursorPos - 1) + text.substring(cursorPos);
      expressionController.text = newText;
      expressionController.selection = TextSelection.collapsed(
        offset: cursorPos - 1,
      );
    }
  }

  void _handleEquals() {
    final text = expressionController.text;
    if (text.isEmpty) return;

    if (answer.isEmpty && double.tryParse(text) == null) {
      answer = 'Invalid Expression';
      return;
    }

    if (answer != 'Undefined' && answer != 'Invalid Expression') {
      expressionController.text = answer;
      expressionController.selection = TextSelection.collapsed(
        offset: answer.length,
      );
      answer = '';
    }
  }

  void _handleInput(String value) {
    final text = expressionController.text;
    if (text.length >= CalculatorConstants.maxExpressionLength) return;

    final selection = expressionController.selection;
    int cursorPos = selection.isValid ? selection.baseOffset : text.length;
    if (cursorPos == -1) cursorPos = text.length;

    final newText =
        text.substring(0, cursorPos) + value + text.substring(cursorPos);
    expressionController.text = newText;
    expressionController.selection = TextSelection.collapsed(
      offset: cursorPos + value.length,
    );
  }

  void _evaluateCurrentExpression() {
    final textForEval = expressionController.text;
    if (textForEval.isNotEmpty) {
      answer = _calculatorService.evaluateExpression(textForEval) ?? '';
    } else {
      answer = '';
    }
  }
}

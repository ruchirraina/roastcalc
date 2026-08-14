import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/calculator_service.dart';
import '../../core/constants/calculator_constants.dart';
import '../../domain/models/history_entry.dart';
import '../../data/repositories/history_repository.dart';

class CalculatorController extends ChangeNotifier {
  final CalculatorService _calculatorService;
  final HistoryRepository _historyRepository;

  final TextEditingController expressionController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String answer = '';
  bool isExpanded = false;

  List<HistoryEntry> history = [];
  bool isHistoryVisible = false;

  CalculatorController(this._calculatorService, this._historyRepository) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    history = await _historyRepository.loadHistory();
    notifyListeners();
  }

  @override
  void dispose() {
    expressionController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToCursor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final text = expressionController.text;
      if (text.isEmpty) return;

      final selection = expressionController.selection;
      final cursorPosition = selection.isValid
          ? selection.baseOffset
          : text.length;

      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: text.substring(0, cursorPosition),
          style: const TextStyle(
            fontFamily: 'SpaceMono',
            fontSize: CalculatorConstants.fontHuge,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final double cursorPixelPosition = painter.width;
      final double viewportWidth = scrollController.position.viewportDimension;
      final double currentScrollOffset = scrollController.offset;
      final double maxScroll = scrollController.position.maxScrollExtent;

      const double padding = 20.0;

      if (cursorPixelPosition > currentScrollOffset + viewportWidth - padding) {
        scrollController.animateTo(
          (cursorPixelPosition - viewportWidth + padding).clamp(0.0, maxScroll),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      } else if (cursorPixelPosition < currentScrollOffset + padding) {
        scrollController.animateTo(
          (cursorPixelPosition - padding).clamp(0.0, maxScroll),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
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
    _scrollToCursor();
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

    if (double.tryParse(text) != null) return;

    if (answer.isEmpty) {
      answer = 'Invalid Expression';
      notifyListeners();
      return;
    }

    if (answer != 'Undefined' && answer != 'Invalid Expression') {
      history.insert(0, HistoryEntry(expression: text, answer: answer));

      if (history.length > 15) {
        history.removeAt(history.length - 1);
      }

      _historyRepository.saveHistory(history);

      expressionController.text = answer;
      expressionController.selection = TextSelection.collapsed(
        offset: answer.length,
      );
      answer = '';
      notifyListeners();
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

  void toggleHistory() {
    isHistoryVisible = !isHistoryVisible;
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    _historyRepository.saveHistory(history);
    notifyListeners();
  }

  void pasteFromHistory(String pastAnswer) {
    if (pastAnswer == 'Undefined' || pastAnswer == 'Invalid Expression') return;

    _handleInput(pastAnswer);
    _evaluateCurrentExpression();
    notifyListeners();
    _scrollToCursor();
  }
}

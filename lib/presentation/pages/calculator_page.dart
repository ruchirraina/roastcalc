import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/services/calculator_service.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/services/gemini_service.dart';
import '../../core/constants/calculator_constants.dart';
import '../constants/calculator_layout.dart';
import '../controllers/calculator_controller.dart';
import '../widgets/calculator_button.dart';
import '../widgets/history_panel.dart';
import '../widgets/roast_panel.dart';
import 'hacks_page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with WidgetsBindingObserver {
  late final CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = CalculatorController(
      CalculatorService(),
      HistoryRepository(),
      GeminiService(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _controller.pauseTimer();
    } else if (state == AppLifecycleState.resumed) {
      _controller.resumeTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(String label, ColorScheme scheme) =>
      switch (label) {
        '÷' ||
        '×' ||
        '-' ||
        '+' ||
        '%' ||
        '!' ||
        '^' ||
        '√x' ||
        '∛x' ||
        '(' ||
        ')' ||
        'x²' ||
        'x³' => scheme.secondary,
        'AC' || '⌫' || 'EXP' => scheme.tertiary,
        '=' => scheme.primaryContainer,
        _ => scheme.primary,
      };

  Color _getTextColor(String label, ColorScheme scheme) => switch (label) {
    '÷' ||
    '×' ||
    '-' ||
    '+' ||
    '%' ||
    '!' ||
    '^' ||
    '√x' ||
    '∛x' ||
    '(' ||
    ')' ||
    'x²' ||
    'x³' => scheme.onSecondary,
    'AC' || '⌫' || 'EXP' => scheme.onTertiary,
    '=' => scheme.onPrimaryContainer,
    _ => scheme.onPrimary,
  };

  double _getFontSize(String label) => switch (label) {
    '÷' || '×' || '-' || '+' || '=' => CalculatorConstants.fontLarge,
    '^' => CalculatorConstants.fontMediumLarge,
    '(' || ')' => CalculatorConstants.fontMediumSmall,
    'x²' || 'x³' || '√x' || '∛x' => CalculatorConstants.fontTiny,
    'AC' || '⌫' => CalculatorConstants.fontSmall,
    'EXP' => CalculatorConstants.fontSmaller,
    _ => CalculatorConstants.fontMedium,
  };

  FontWeight _getFontWeight(String label) => switch (label) {
    'x²' || 'x³' || '√x' || '∛x' || 'AC' || '⌫' => FontWeight.bold,
    '(' || ')' || '!' || '%' => FontWeight.w500,
    _ => FontWeight.normal,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: CalculatorConstants.gridPadding * 1.5,
                          vertical: CalculatorConstants.gridPadding / 2,
                        ),
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    Colors.white,
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.015, 0.985, 1.0],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: TextField(
                                controller: _controller.expressionController,
                                scrollController: _controller.scrollController,
                                readOnly: true,
                                showCursor: true,
                                autofocus: true,
                                cursorColor: colorScheme.primaryContainer,
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: CalculatorConstants.fontHuge,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _controller.answer,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: CalculatorConstants.fontSmall,
                                    color: colorScheme.primaryContainer,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: CalculatorConstants.gridPadding / 2,
                        child: IconButton(
                          iconSize: 28,
                          splashRadius: 24,
                          icon: AnimatedSwitcher(
                            duration: CalculatorConstants.animNormal,
                            transitionBuilder: (child, animation) {
                              return RotationTransition(
                                turns: child.key == const ValueKey('close')
                                    ? Tween<double>(
                                        begin: -0.5,
                                        end: 0,
                                      ).animate(animation)
                                    : Tween<double>(
                                        begin: 0.5,
                                        end: 0,
                                      ).animate(animation),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: _controller.isHistoryVisible
                                ? Icon(
                                    Icons.close,
                                    key: const ValueKey('close'),
                                    color: colorScheme.onSurface,
                                  )
                                : Icon(
                                    Icons.history,
                                    key: const ValueKey('history'),
                                    color: colorScheme.onSurface,
                                  ),
                          ),
                          onPressed: _controller.toggleHistory,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: RoastPanel(
                    currentRoast: _controller.currentRoast,
                    onFireTapped: () async {
                      _controller.pauseTimer();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HacksPage(),
                        ),
                      );
                      _controller.resumeTimer();
                    },
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final int activeRows =
                          (_controller.isExpanded ||
                              _controller.isHistoryVisible)
                          ? CalculatorConstants.expandedRows
                          : CalculatorConstants.standardRows;

                      final double availableWidth =
                          constraints.maxWidth -
                          (CalculatorConstants.gridPadding * 2) -
                          (CalculatorConstants.buttonSpacing *
                              (CalculatorConstants.maxColumns - 1));

                      final double availableHeight =
                          constraints.maxHeight -
                          (CalculatorConstants.gridPadding * 2) -
                          (CalculatorConstants.buttonSpacing *
                              (activeRows - 1));

                      final double buttonWidth =
                          availableWidth / CalculatorConstants.maxColumns;
                      final double buttonHeight = availableHeight / activeRows;

                      final double panelWidth =
                          (buttonWidth * 3) +
                          (CalculatorConstants.buttonSpacing * 2);

                      return ClipRect(
                        child: Padding(
                          padding: const EdgeInsets.all(
                            CalculatorConstants.gridPadding,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ...CalculatorLayout.keys.map((keyData) {
                                int currentRow =
                                    (_controller.isExpanded ||
                                        _controller.isHistoryVisible)
                                    ? keyData.row
                                    : keyData.row - 2;
                                int currentCol = keyData.col;
                                bool isVisible =
                                    _controller.isExpanded ||
                                    !keyData.isExpandedOnly;

                                if (_controller.isHistoryVisible) {
                                  isVisible = keyData.isVisibleInHistory;
                                  if (isVisible) {
                                    currentCol =
                                        keyData.historyCol ?? keyData.col;
                                    currentRow =
                                        keyData.historyRow ?? keyData.row;
                                  }
                                }

                                final double leftPos =
                                    currentCol *
                                    (buttonWidth +
                                        CalculatorConstants.buttonSpacing);
                                final double topPos =
                                    currentRow *
                                    (buttonHeight +
                                        CalculatorConstants.buttonSpacing);

                                IconData? icon;
                                if (keyData.label == 'EXP') {
                                  icon = _controller.isExpanded
                                      ? Icons.unfold_less
                                      : Icons.unfold_more;
                                }

                                return AnimatedPositioned(
                                  duration: CalculatorConstants.animNormal,
                                  curve: Curves.easeOut,
                                  left: leftPos,
                                  top: topPos,
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  child: AnimatedOpacity(
                                    duration: CalculatorConstants.animFast,
                                    opacity: isVisible ? 1.0 : 0.0,
                                    child: IgnorePointer(
                                      ignoring: !isVisible,
                                      child: RepaintBoundary(
                                        child: CalculatorButton(
                                          label: keyData.label == 'EXP'
                                              ? null
                                              : keyData.label,
                                          icon: icon,
                                          backgroundColor: _getBackgroundColor(
                                            keyData.label,
                                            colorScheme,
                                          ),
                                          textColor: _getTextColor(
                                            keyData.label,
                                            colorScheme,
                                          ),
                                          fontSize: _getFontSize(keyData.label),
                                          fontWeight: _getFontWeight(
                                            keyData.label,
                                          ),
                                          onTap: () {
                                            if (keyData.label == '=' ||
                                                keyData.label == 'AC') {
                                              HapticFeedback.vibrate();
                                            }
                                            _controller.handleButtonTap(
                                              keyData.label,
                                              keyData.value,
                                            );
                                          },
                                          onLongPress: keyData.label == '⌫'
                                              ? () {
                                                  HapticFeedback.vibrate();
                                                  _controller
                                                      .handleBackspaceLongPress();
                                                }
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              AnimatedPositioned(
                                duration: CalculatorConstants.animNormal,
                                curve: Curves.easeOut,
                                top: 0,
                                bottom: 0,
                                left: _controller.isHistoryVisible
                                    ? 0
                                    : -(panelWidth +
                                          CalculatorConstants.gridPadding * 2),
                                width: panelWidth,
                                child: RepaintBoundary(
                                  child: HistoryPanel(controller: _controller),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

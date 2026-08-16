import 'package:flutter/material.dart';
import '../../core/constants/calculator_constants.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/hacks_repository.dart';
import '../../data/services/gemini_service.dart';
import '../controllers/hacks_controller.dart';
import '../widgets/hacks_chips_view.dart';
import '../widgets/hacks_explanation_view.dart';

class HacksPage extends StatefulWidget {
  const HacksPage({super.key});

  @override
  State<HacksPage> createState() => _HacksPageState();
}

class _HacksPageState extends State<HacksPage> {
  late final HacksController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HacksController(
      HistoryRepository(),
      HacksRepository(),
      GeminiService(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.toString();
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Math Hacks',
          style: textTheme.bodyMedium?.copyWith(
            fontSize: CalculatorConstants.fontMediumSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildCurrentState(colorScheme, textTheme),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentState(ColorScheme colorScheme, TextTheme textTheme) {
    switch (_controller.currentState) {
      case HacksState.initializing:
        return Container(
          key: const ValueKey('init'),
          color: colorScheme.surface,
        );

      case HacksState.loadingChips:
      case HacksState.loadingExplanation:
        return Center(
          key: const ValueKey('loading'),
          child: CircularProgressIndicator(color: colorScheme.primaryContainer),
        );

      case HacksState.showingChips:
        return HacksChipsView(
          key: const ValueKey('chips'),
          chips: _controller.chips,
          onChipSelected: (chip) => _controller.loadExplanation(chip),
        );

      case HacksState.showingExplanation:
        return HacksExplanationView(
          key: const ValueKey('explanation'),
          explanation: _controller.explanation,
          remainingTime: _controller.remainingTime,
          onRequestMore: _controller.loadChips,
        );

      case HacksState.cooldown:
        return Center(
          key: const ValueKey('cooldown'),
          child: Padding(
            padding: const EdgeInsets.all(
              CalculatorConstants.gridPadding * 1.5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You just pulled a hack.",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "Give me a few minutes to recharge.",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 16.0,
                    color: colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      color: colorScheme.secondary,
                      size: 40.0,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      _formatDuration(_controller.remainingTime),
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case HacksState.error:
        return Center(
          key: const ValueKey('error'),
          child: Padding(
            padding: const EdgeInsets.all(
              CalculatorConstants.gridPadding * 1.5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Couldn't connect. Either you went offline to dodge my roasts, or our servers gave you a free pass.",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _controller.retry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                  ),
                  child: const Text("TRY AGAIN"),
                ),
              ],
            ),
          ),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../core/constants/calculator_constants.dart';

class HacksExplanationView extends StatelessWidget {
  final String explanation;
  final Duration remainingTime;
  final VoidCallback onRequestMore;

  const HacksExplanationView({
    super.key,
    required this.explanation,
    required this.remainingTime,
    required this.onRequestMore,
  });

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.toString();
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(CalculatorConstants.gridPadding * 1.5),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: MarkdownBody(
                  data: explanation,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: textTheme.bodyMedium?.copyWith(
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                    strong: textTheme.bodyMedium?.copyWith(
                      fontSize: 16.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primaryContainer,
                    ),
                    em: textTheme.bodyMedium?.copyWith(
                      fontSize: 16.0,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                    code: textTheme.bodyMedium?.copyWith(
                      fontSize: 14.0,
                      backgroundColor: colorScheme.surface,
                      color: colorScheme.primaryContainer,
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: colorScheme.tertiary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: remainingTime.inSeconds > 0
                ? Container(
                    key: const ValueKey('timer_box'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border.all(
                        color: colorScheme.tertiary.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          color: colorScheme.secondary,
                          size: 32.0,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Next generation available in:",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: 15.0,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                _formatDuration(remainingTime),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    key: const ValueKey('action_button'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border.all(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: OutlinedButton(
                      onPressed: onRequestMore,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        foregroundColor: colorScheme.primaryContainer,
                      ),
                      child: const Text("Want some more hacks?"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

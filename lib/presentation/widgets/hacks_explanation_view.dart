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
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.02, 0.97, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
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
                        borderRadius: BorderRadius.circular(
                          CalculatorConstants.borderRadiusSmall,
                        ),
                        border: Border.all(
                          color: colorScheme.tertiary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Material(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                CalculatorConstants.borderRadius,
              ),
              side: BorderSide(
                color: remainingTime.inSeconds > 0
                    ? colorScheme.tertiary.withValues(alpha: 0.3)
                    : colorScheme.primaryContainer.withValues(alpha: 0.5),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: remainingTime.inSeconds > 0 ? null : onRequestMore,
              child: AnimatedContainer(
                duration: CalculatorConstants.animSlow,
                height: 92.0, // Kept local: Structural constraint
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: CalculatorConstants.animSlow,
                  child: remainingTime.inSeconds > 0
                      ? Row(
                          key: const ValueKey('timer_content'),
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
                                mainAxisSize: MainAxisSize.min,
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
                        )
                      : Text(
                          "Want some more hacks?",
                          key: const ValueKey('action_content'),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

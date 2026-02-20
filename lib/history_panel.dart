import 'package:flutter/material.dart';
import 'package:roastcalc/services/theme_extension.dart';
import 'package:roastcalc/one_history.dart';

class HistoryPanel extends StatelessWidget {
  // list of strings of format: expression=answer
  final List<String> history;
  // key for animated list in history panel
  final GlobalKey<AnimatedListState> historyListKey;
  // #include<iostream> using
  final Duration animDuration;
  // recieve function - what to do when user taps a history
  final void Function(int, String) changeCurrentChunk;
  // recieve fucntion - what to do when user delete icon button for a history
  final void Function(int) clearThisHistory;
  // recieve fucntion - what to do when user taps clear history button
  final void Function() clearHistroy;
  const HistoryPanel({
    required this.history,
    required this.historyListKey,
    required this.animDuration,
    required this.changeCurrentChunk,
    required this.clearThisHistory,
    required this.clearHistroy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // color match surface
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: .circular(8), // cool
      ),
      child: Column(
        children: [
          Expanded(
            flex: 9,
            // dynamic scrollable list of past calculations
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: (history.isEmpty) ? 0.55 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Padding(
                          padding: const .all(8),
                          child: Image.asset(
                            (context.theme.brightness == .dark)
                                ? 'lib/assets/no_history_dark_mode.png'
                                : 'lib/assets/no_history_light_mode.png',
                            width: 75,
                            height: 75,
                          ),
                        ),
                        FittedBox(
                          fit: .scaleDown,
                          child: Text(
                            'NO HISTORY',
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: AnimatedList(
                      key: historyListKey,
                      // number of past calculations
                      initialItemCount: history.length,
                      itemBuilder: (context, index, animation) {
                        // store current expression
                        String expression = history[index].split('=').first;
                        // store current answer
                        String answer = history[index].split('=').last;
                        return OneHistory(
                          expression: expression,
                          answer: answer,
                          animation: animation,
                          changeCurrentChunk: () =>
                              changeCurrentChunk(index, answer),
                          clearThisHistory: () => clearThisHistory(index),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // no history
          ),
          // clear History Button
          Expanded(
            flex: 1,
            child: ElevatedButton.icon(
              onPressed: clearHistroy,
              icon: Icon(Icons.delete, color: context.colorScheme.error), //red
              label: FittedBox(
                fit: .scaleDown,
                child: Text(
                  'CLEAR HISTORY',
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontWeight: .bold, // emphasize
                    color: context.colorScheme.error, // red
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                // expand to panel width
                minimumSize: const Size(.infinity, .infinity),
                // cool
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

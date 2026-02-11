import 'package:flutter/material.dart';
import 'package:roastcalc/theme_extension.dart';

class HistoryPanel extends StatelessWidget {
  // list of equation and answer strings
  final List<(String, String)> history;
  // recieve function - what to do when user taps a history
  final void Function(int, String) changeCurrentChunk;
  // recieve fucntion - what to do when user delete icon button for a history
  final void Function(int) clearThisHistory;
  // recieve fucntion - what to do when user taps clear history button
  final void Function() clearHistroy;
  const HistoryPanel({
    required this.history,
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
            child: ListView.builder(
              // number of past calculations
              itemCount: history.length,
              itemBuilder: (context, index) {
                // store current equation
                String equation = history[index].$1;
                // store current answer
                String answer = history[index].$2;
                return Card(
                  child: Padding(
                    padding: const .all(8), // cool
                    // equation and answers and delete this history
                    child: Row(
                      // seperate on either ends
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => changeCurrentChunk(index, answer),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(equation),
                                FittedBox(
                                  fit: .scaleDown,
                                  child: Text(
                                    '= $answer', // = sign before answer
                                    style: context.textTheme.titleLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // delete button for deletion of current history
                        IconButton(
                          onPressed: () => clearThisHistory(index),
                          icon: Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 8, thickness: 2),
          // clear History Button
          Expanded(
            flex: 1,
            child: ElevatedButton.icon(
              onPressed: clearHistroy,
              icon: Icon(Icons.delete, color: context.colorScheme.error), //red
              label: Text(
                'CLEAR HISTORY',
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: .bold, // emphasize
                  color: context.colorScheme.error, // red
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

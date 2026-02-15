import 'package:flutter/material.dart';
import 'package:roastcalc/services/theme_extension.dart';

class OneHistory extends StatelessWidget {
  // expression and answer for this history
  final String expression;
  final String answer;
  // animation for this history when it enters or leaves the panel
  final Animation<double> animation;
  // recieve function - what to do when user taps a history
  final void Function() changeCurrentChunk;
  // recieve fucntion - what to do when user delete icon button for a history
  final void Function() clearThisHistory;

  const OneHistory({
    required this.expression,
    required this.answer,
    required this.animation,
    required this.changeCurrentChunk,
    required this.clearThisHistory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    return SizeTransition(
      sizeFactor: curvedAnimation,
      child: FadeTransition(
        opacity: curvedAnimation,
        child: Card(
          child: Padding(
            padding: const .all(8), // cool
            // equation and answers and delete this history
            child: Row(
              // seperate on either ends
              mainAxisAlignment: .spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => changeCurrentChunk(),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(expression),
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
                  onPressed: () => clearThisHistory(),
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

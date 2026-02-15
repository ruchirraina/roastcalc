import 'package:flutter/material.dart';
import 'dart:async';
import 'package:roastcalc/services/theme_extension.dart';

class DisplayArea extends StatelessWidget {
  // height of display area
  final double displayHeight;
  // width of display area
  final double displayWidth;

  // list of string chunks that make up expression
  final List<String> expression;
  // index of chunk currently focussed
  final int focussedChunk;
  // recieve fucntion - what to do when user taps a specific chunk
  final void Function(int) onChunkTap;
  //reieve answer
  final String answer;

  const DisplayArea({
    required this.displayHeight,
    required this.displayWidth,
    required this.expression,
    required this.focussedChunk,
    required this.onChunkTap,
    required this.answer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // calculate dynamic size
    final int length = expression.join().length;
    double dynamicFontSize;

    if (length <= 8) {
      dynamicFontSize = displayHeight - 56;
    } else if (length <= 12) {
      dynamicFontSize = displayHeight - 64;
    } else {
      dynamicFontSize = displayHeight - 72;
    }
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        // right allign text and cursor
        crossAxisAlignment: .end,
        mainAxisAlignment: .spaceBetween,
        children: [
          SizedBox(
            height: displayHeight - 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: expression.length,
              itemBuilder: (context, index) {
                // reversed - 0 index here is the last item in expression list
                final int correctIndex = expression.length - 1 - index;
                // get specific chunk
                final String chunk = expression[correctIndex];
                // check if this is the one selected
                final bool isChunkFocussed = (correctIndex == focussedChunk);

                return GestureDetector(
                  // trigger what to do when chunk tapped
                  onTap: () => onChunkTap(correctIndex),
                  child: Row(
                    crossAxisAlignment: .end,
                    children: [
                      Opacity(
                        opacity: isChunkFocussed ? 1 : 0.6,
                        child: Text(
                          // show cursor even if expression is just one chunk ''
                          (focussedChunk == 0 && chunk == '') ? ' ' : chunk,
                          style: TextStyle(
                            fontSize: dynamicFontSize, // use calculated size
                          ),
                        ),
                      ),
                      // only show cursor if this chunk is active
                      if (isChunkFocussed)
                        Cursor(blinkerHeight: displayHeight - 56),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const .symmetric(vertical: 8),
            child: FittedBox(
              fit: .scaleDown,
              child: Text(
                answer,
                style:
                    !(answer == 'Infinity' ||
                        answer == '-Infinity' ||
                        answer == 'Indeterminate')
                    ? context.textTheme.headlineSmall
                    : context.textTheme.headlineSmall!.copyWith(
                        color: context.colorScheme.error,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// widget for blinking cursor
class Cursor extends StatefulWidget {
  final double blinkerHeight;
  const Cursor({required this.blinkerHeight, super.key});

  @override
  State<Cursor> createState() => _CursorState();
}

class _CursorState extends State<Cursor> {
  bool _visible = false; // controls cursor visibility - toggled by timer
  late Timer _timer; // timer to toggle visibility every 500ms

  // immediately start timer on widget creation
  @override
  void initState() {
    super.initState();
    // toggle visibility every 500ms
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _visible = !_visible; // toggle visibility
      });
    });
  }

  @override
  void dispose() {
    // cancel timer - good practice
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.blinkerHeight,
      // draw thin line that blinks
      child: VerticalDivider(
        // transparent when hidden, primary color when visible
        color: _visible ? context.colorScheme.primary : Colors.transparent,
        width: 2, // minimal
        thickness: 2,
      ),
    );
  }
}

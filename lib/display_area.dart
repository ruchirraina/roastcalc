import 'package:flutter/material.dart';
import 'dart:async';
import 'package:roastcalc/theme_extension.dart';

class DisplayArea extends StatelessWidget {
  // list of string chunks that make up expression
  final List<String> expression;
  // index of chunk currently focussed
  final int focussedChunk;
  // recieve fucntion - what to do when user taps a specific chunk
  final void Function(int) onChunkTap;
  //reieve answer
  final String answer;

  const DisplayArea({
    required this.expression,
    required this.focussedChunk,
    required this.onChunkTap,
    required this.answer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      // keep calculator text at top right
      alignment: .topRight,
      child: Column(
        // right allign text and cursor
        crossAxisAlignment: .end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            // need constrained height or listview crashes app
            child: SizedBox(
              height: 64,
              child: ListView.builder(
                scrollDirection: .horizontal,
                // start from right side
                reverse: true,
                itemCount: expression.length, // dictated by number of chunks
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
                      children: [
                        Text(chunk, style: context.textTheme.displayLarge),
                        // only show cursor if this chunk is active
                        if (isChunkFocussed) const Cursor(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            answer,
            style:
                !(answer == '∞' || answer == '−∞' || answer == 'Indeterminate')
                ? context.textTheme.headlineMedium
                : context.textTheme.headlineMedium!.copyWith(
                    color: context.colorScheme.error,
                  ),
          ),
        ],
      ),
    );
  }
}

// widget for blinking cursor
class Cursor extends StatefulWidget {
  const Cursor({super.key});

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
      height: 64,
      // draw thin line that blinks
      child: VerticalDivider(
        // transparent when hidden, primary color when visible
        color: _visible ? context.colorScheme.primary : Colors.transparent,
        width: 0,
        thickness: 2,
      ),
    );
  }
}

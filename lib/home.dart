import 'package:flutter/material.dart';
import 'package:roastcalc/info_popup.dart';
import 'package:roastcalc/display_area.dart';
import 'package:roastcalc/roast_area.dart';
import 'package:roastcalc/button_grid.dart';
import 'package:roastcalc/history_panel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // holds history panel visibility info and controls grid layout
  bool _panelOpen = false;

  // entire expression is divided into list of chunks - format example: '67+'
  // initially one empty '' chunk
  List<String> _expression = [''];
  // current focussed chunk index - initially first(0)
  int _focussedChunk = 0;

  void _onButtonPress(String input) {
    // clear expression - back to just one chunk '' and focussed index - 0
    if (input == 'AC') {
      setState(() {
        _expression = [''];
        _focussedChunk = 0;
      });
      return;
    }

    // current chunk
    String currentChunk = _expression[_focussedChunk];

    // backspace logic
    if (input == 'DEL') {
      // if empty - don't allow
      if (currentChunk.isEmpty) return;

      setState(() {
        // remove last character
        _expression[_focussedChunk] = currentChunk.substring(
          0,
          currentChunk.length - 1,
        );
        // if now chunk empty - remove it - shift focus previous chunk if !last
        if (_expression.length > 1 &&
            currentChunk.substring(0, currentChunk.length - 1) == '') {
          _expression.removeAt(_focussedChunk);
          _focussedChunk--;
        }
      });
      return;
    }

    final bool currentChunkEndsWithOperator =
        (currentChunk.endsWith('%') ||
        currentChunk.endsWith('÷') ||
        currentChunk.endsWith('×') ||
        currentChunk.endsWith('−') ||
        currentChunk.endsWith('+'));

    final bool isInputNumberOrDecimal =
        (num.tryParse(input) != null || input == '00' || input == '.');

    // new chunk creation
    if (currentChunkEndsWithOperator && isInputNumberOrDecimal) {
      // conver 00 to 0 if new chunk empty
      if (input == '00') input = '0';
      // conver . to 0. if new chunk empty
      if (input == '.') input = '0.';

      // move focus to new chunk and insert input there
      _focussedChunk++;
      setState(() {
        // in bewteen
        if (_focussedChunk < _expression.length) {
          _expression.insert(_focussedChunk, input);
          // at end
        } else {
          _expression.add(input);
        }
      });
      return;
    }

    final bool isInputOperator =
        (input == '%' ||
        input == '÷' ||
        input == '×' ||
        input == '−' ||
        input == '+');

    final bool isInputOperatorExceptMinus =
        (input == '%' || input == '÷' || input == '×' || input == '+');

    // validaton for chunk

    if (currentChunk.isEmpty) {
      // conver 00 to 0 if chunk empty
      if (input == '00') input = '0';
      // conver . to 0. if chunk empty
      if (input == '.') input = '0.';
      // not allow any operator except − if chunk empty
      if (isInputOperatorExceptMinus) return;
      /* handle trailing zeroes at start - not allow
       * not allow futher 0 or 00
       * if other num input whether just 0 or -0 it becomes num or -num
       * if not num input . or operators allowed */
    } else if ((currentChunk == '0' || currentChunk == '−0') &&
        !(input == '.' || isInputOperator)) {
      if (input != '00' && input != '0') {
        setState(() {
          _expression[_focussedChunk] = (currentChunk == '-0')
              ? '−$input'
              : input;
        });
      }
      return;
      // only one . in a chunk
    } else if (input == '.' && currentChunk.contains('.')) {
      return;
      // don't allow operator if end at decimal
    } else if (isInputOperator &&
        currentChunk[currentChunk.length - 1] == '.') {
      return;
      // if ends with operator and operator input - replace it with input
    } else if (isInputOperator && currentChunkEndsWithOperator) {
      // exception if just −
      if (currentChunk == '−') return;
      setState(() {
        _expression[_focussedChunk] =
            currentChunk.substring(0, currentChunk.length - 1) + input;
      });
      return;
    }

    // write input
    setState(() {
      _expression[_focussedChunk] = currentChunk + input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // keyboard won't pop up but i dont want it resizing the screen anyways
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        // history button - rn trigger grid changes and slides history panel
        leading: IconButton(
          onPressed: () {
            setState(() {
              _panelOpen = !_panelOpen;
            });
          },
          // basic anim switch between history and close icon
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _panelOpen ? Icon(Icons.close) : Icon(Icons.history),
          ),
        ),
        // info about app and me
        actions: [
          IconButton(
            onPressed: () => showInfoPopUp(context),
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),

      // nav buttons in some androids overlay so safe area
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 15,
              // expression and answer
              child: DisplayArea(
                expression: _expression,
                focussedChunk: _focussedChunk,
                onChunkTap: (int focusOnChunk) {
                  setState(() {
                    _focussedChunk = focusOnChunk;
                  });
                },
              ),
            ),
            // TODO: implement - roast area
            Expanded(flex: 20, child: RoastArea()),
            Expanded(
              flex: 65,
              child: Padding(
                padding: const .symmetric(vertical: 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // box height that holds circular button with padding
                    final double boxHeight = constraints.maxHeight / 5;
                    // box height shrink that holds circular button with padding
                    final double boxHeightShrink = constraints.maxHeight / 6;
                    // box width that holds circular button with padding
                    final double boxWidth = constraints.maxWidth / 4;

                    // stack with history panel on top and button grid at bottom
                    return Stack(
                      children: [
                        // bottom
                        ButtonGrid(
                          boxWidth: boxWidth,
                          boxHeight: boxHeight,
                          boxHeightShrink: boxHeightShrink,
                          panelOpen: _panelOpen,
                          onButtonPress: _onButtonPress,
                        ),
                        // top
                        AnimatedPositioned(
                          // left of screen boundaries orignally
                          left: _panelOpen ? 0 : -(boxWidth * 3),
                          height: constraints.maxHeight,
                          width: 3 * boxWidth,
                          // appropriate duration
                          duration: const Duration(milliseconds: 300),
                          // approrpriate curve
                          curve: Curves.fastOutSlowIn,
                          child: HistoryPanel(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:roastcalc/services/history_storage.dart';
import 'package:roastcalc/info_popup.dart';
import 'package:roastcalc/services/expression_eval.dart';
import 'package:roastcalc/display_area.dart';
import 'package:roastcalc/roast_area.dart';
import 'package:roastcalc/button_grid.dart';
import 'package:roastcalc/history_panel.dart';
import 'package:roastcalc/one_history.dart';

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

  String _answer = '';

  // list of equation and answer strings
  final List<String> _history = HistoryStorage.getHistory();

  // key for animated list in history panel
  final GlobalKey<AnimatedListState> _historyListKey =
      GlobalKey<AnimatedListState>();

  // duration for animations in history panel
  final Duration _animDuration = const Duration(milliseconds: 300);

  void _onButtonPress(String input) {
    if (input == '=') {
      // not allow further operation just limit to answer display
      if (_answer == 'Infinity' ||
          _answer == '−Infinity' ||
          _answer == 'Indeterminate') {
        return;
      }
      setState(() {
        if (_answer.isNotEmpty) {
          // store in history
          _history.insert(0, '${_expression.join()}=$_answer');
          _historyListKey.currentState?.insertItem(0, duration: _animDuration);
          HistoryStorage.addHistory(expressionAnswerList: _history);
          _expression = [_answer]; // new expression is just the answer chunk
        }
        _focussedChunk = 0; // focus on that chunk
        _answer = ''; // clear answer until next expression change
      });
      return;
    }

    // clear expression - back to just one chunk '' and focussed index - 0
    if (input == 'AC') {
      setState(() {
        _expression = [''];
        _focussedChunk = 0;
        _answer = '';
      });
      return;
    }

    // current chunk
    String currentChunk = _expression[_focussedChunk];

    final bool currentChunkEndsWithOperator =
        (currentChunk.endsWith('%') ||
        currentChunk.endsWith('÷') ||
        currentChunk.endsWith('×') ||
        currentChunk.endsWith('−') ||
        currentChunk.endsWith('+'));

    // backspace logic
    if (input == 'DEL') {
      // if empty - don't allow
      if (currentChunk.isEmpty) return;

      setState(() {
        // remove last character if one chunk or at last chunk
        if (_expression.length == 1 ||
            _focussedChunk == _expression.length - 1) {
          _expression[_focussedChunk] = currentChunk.substring(
            0,
            currentChunk.length - 1,
          );
          // if now chunk empty - remove it - shift focus previous chunk if !last
          // exception: remain first if removing first chunk and chunks was > 1
          if (_expression.length > 1 &&
              currentChunk.substring(0, currentChunk.length - 1) == '') {
            _expression.removeAt(_focussedChunk);
            if (_focussedChunk != 0) _focussedChunk--;
          }
          _updateAnswer();
          // if chunk in between or start and chunk ends with operator
          // remove operator at end of chunk
          // join it with next chunk and remove this chunk - shift focus to it
        } else {
          // handle case of two decimals in a row -
          // if current chunk and next chunk have decimals and remove later's .
          final String nextChunkWithNoDecimals =
              (currentChunk.contains('.') &&
                  _expression[_focussedChunk + 1].contains('.'))
              ? _expression[_focussedChunk + 1].replaceAll('.', '')
              : _expression[_focussedChunk + 1];
          _expression[_focussedChunk + 1] =
              currentChunk.substring(0, currentChunk.length - 1) +
              nextChunkWithNoDecimals;
          _expression.removeAt(_focussedChunk);
          _updateAnswer();
        }
      });
      return;
    }

    final bool isInputNumberOrDecimal =
        (num.tryParse(input) != null || input == '00' || input == '.');

    // new chunk creation
    if (currentChunkEndsWithOperator &&
        currentChunk != '−' &&
        isInputNumberOrDecimal) {
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
        _updateAnswer();
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
          _updateAnswer();
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
        _updateAnswer();
      });
      return;
    }

    // write input
    setState(() {
      _expression[_focussedChunk] = currentChunk + input;
      _updateAnswer();
    });
  }

  void _updateAnswer() {
    // evaluate expression and update answer every time expression changes
    // except when just one chunk as that is not really an expression
    if (_expression.length > 1 || _expression[_focussedChunk].endsWith('%')) {
      setState(() {
        _answer = expressionEvaluator(_expression.join());
      });
    } else {
      setState(() {
        _answer = '';
      });
    }
  }

  // change current chunk implementation
  void _changeCurrentChunk(int index, String answer) {
    // current chunk
    String currentChunk = _expression[_focussedChunk];

    final bool currentChunkEndsWithOperator =
        (currentChunk.endsWith('%') ||
        currentChunk.endsWith('÷') ||
        currentChunk.endsWith('×') ||
        currentChunk.endsWith('−') ||
        currentChunk.endsWith('+'));

    if (currentChunkEndsWithOperator && currentChunk != '−') {
      // prevent −− double
      if (currentChunk.endsWith('−') && answer.startsWith('−')) {
        answer = answer.substring(1);
      }
      // more than one chunk and in between ends with operator
      if (_focussedChunk < (_expression.length - 1)) {
        // replace chunk but append with operator
        setState(() {
          _expression[_focussedChunk] =
              answer + currentChunk[currentChunk.length - 1];
          _updateAnswer();
        });
        // more than one chunk and at end or just one chunk ends with operator
      } else if (_focussedChunk == _expression.length - 1) {
        // move focus to new chunk and insert input there
        _focussedChunk++;
        setState(() {
          _expression.add(answer);
          _updateAnswer();
        });
      }
      return;
    }

    // one chunk does not end with operator
    if (currentChunk == '−') {
      setState(() {
        _expression[_focussedChunk] = '-$answer';
        _updateAnswer();
      });
    } else {
      setState(() {
        _expression[_focussedChunk] = answer;
        _updateAnswer();
      });
    }
  }

  // clear a history
  void _clearThisHistory(int index) {
    String removedItem = _history[index];
    setState(() {
      _history.removeAt(index);
      _historyListKey.currentState?.removeItem(
        index,
        (context, animation) => OneHistory(
          expression: removedItem.split('=').first,
          answer: removedItem.split('=').last,
          animation: animation,
          changeCurrentChunk: () {},
          clearThisHistory: () {},
        ),
        duration: _animDuration,
      );
      HistoryStorage.addHistory(expressionAnswerList: _history);
    });
  }

  // clear all history
  void _clearAllHistory() {
    // loop through and delete all histories
    for (int i = _history.length - 1; i >= 0; i--) {
      String removedItem = _history[i];
      setState(() {
        _history.removeAt(i);
        _historyListKey.currentState?.removeItem(
          i,
          (context, animation) => OneHistory(
            expression: removedItem.split('=').first,
            answer: removedItem.split('=').last,
            animation: animation,
            changeCurrentChunk: () {}, // it's being removed
            clearThisHistory: () {}, // it's being removed
          ),
          duration: _animDuration,
        );
      });
    }
    HistoryStorage.addHistory(expressionAnswerList: _history);
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
            // expression and answer - display area
            Expanded(
              flex: 15,
              child: Padding(
                padding: const .symmetric(horizontal: 4),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // height of display area
                    final double displayHeight = constraints.maxHeight;
                    // width of display area
                    final double displayWidth = constraints.maxWidth;
                    return DisplayArea(
                      displayHeight: displayHeight,
                      displayWidth: displayWidth,
                      expression: _expression,
                      focussedChunk: _focussedChunk,
                      onChunkTap: (int focusOnChunk) {
                        // must end with operator when inserting chunk in b/w
                        if (_focussedChunk > 0 &&
                            _focussedChunk < _expression.length - 1 &&
                            !(_expression[_focussedChunk].endsWith('%') ||
                                _expression[_focussedChunk].endsWith('÷') ||
                                _expression[_focussedChunk].endsWith('×') ||
                                _expression[_focussedChunk].endsWith('−') ||
                                _expression[_focussedChunk].endsWith('+'))) {
                          return;
                        }
                        setState(() {
                          _focussedChunk = focusOnChunk;
                        });
                      },
                      answer: _answer,
                    );
                  },
                ),
              ),
            ),

            Expanded(flex: 20, child: RoastArea(history: _history)),
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
                          child: HistoryPanel(
                            history: _history,
                            historyListKey: _historyListKey,
                            animDuration: _animDuration,
                            changeCurrentChunk: _changeCurrentChunk,
                            clearThisHistory: _clearThisHistory,
                            clearHistroy: _clearAllHistory,
                          ),
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

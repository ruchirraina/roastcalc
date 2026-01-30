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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // TODO: implement - display area
            Expanded(flex: 15, child: DisplayArea()),
            // TODO: implement - roast area
            Expanded(flex: 20, child: RoastArea()),
            //TODO: implement - calculator grid - rn animated but non functional
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

import 'package:flutter/material.dart';
import 'package:roastcalc/button_grid.dart';
import 'package:roastcalc/theme_extension.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // controls if history slide panel visibile or not and grid layout
  bool _panelOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // history Button - rn trigger grid animation and slides panel but empty
        // TODO: implement scrollable list that shows history of calculations
        leading: IconButton(
          onPressed: () {
            setState(() {
              _panelOpen = !_panelOpen;
            });
          },
          icon: Icon(Icons.history),
        ),
        // info about app and me
        // TODO: implement popup that displays app version and my tech socials
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))],
      ),

      // nav buttons in some androids overlay so safe area
      body: SafeArea(
        child: Column(
          children: [
            // TODO: implement - display + roast
            Expanded(
              flex: 3,
              child: Container(color: context.colorScheme.secondary),
            ),
            //TODO: implement - calculator grid - rn animated but non functional
            Expanded(
              flex: 5,
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
                        child: Card(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

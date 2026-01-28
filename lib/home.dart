import 'package:flutter/material.dart';
import 'package:roastcalc/button_grid.dart';
import 'package:roastcalc/theme_extension.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // history Button
        // TODO: implement slide panel that shows history of applications
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.history)),
        // info about app and me
        // TODO: implement popup that displays app version and my tech socials
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))],
      ),

      body: Column(
        children: [
          // TODO: implement - display + roast
          Expanded(
            flex: 3,
            child: Container(color: context.colorScheme.secondary),
          ),
          //TODO: implement - calculator grid (first visual then working)
          Expanded(
            flex: 5,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // box width that holds circular button with padding
                final double boxWidth = constraints.maxWidth / 4;
                // box height that holds circular button with padding
                final double boxHeight = constraints.maxHeight / 5;

                return ButtonGrid(boxWidth: boxWidth, boxHeight: boxHeight);
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:roastcalc/theme_extension.dart';

void sendInput(String input) {}

class DisplayArea extends StatefulWidget {
  const DisplayArea({super.key});

  @override
  State<DisplayArea> createState() => _DisplayAreaState();
}

class _DisplayAreaState extends State<DisplayArea> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topRight,
      child: Column(
        crossAxisAlignment: .end, // right alignment of text
        children: [
          // just a text 'equation'
          Text('equation', style: context.textTheme.displayLarge),
          // just a text 'answer'
          Text('answer', style: context.textTheme.headlineMedium),
        ],
      ),
    );
  }
}

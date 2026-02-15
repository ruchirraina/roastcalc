// TODO: implement - dynamic ai generated roasts
import 'package:flutter/material.dart';
import 'package:roastcalc/services/theme_extension.dart';

class RoastArea extends StatelessWidget {
  const RoastArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          FittedBox(
            fit: .scaleDown,
            child: Text('🔥', style: context.textTheme.displayMedium),
          ),
          const VerticalDivider(),
          Expanded(
            child: const Text('lol imagine having a brain and using me...🥀'),
          ),
        ],
      ),
    );
  }
}

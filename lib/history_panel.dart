import 'package:flutter/material.dart';
import 'package:roastcalc/theme_extension.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // TODO: Implement Scrollable list of past calculations
          Expanded(flex: 9, child: SizedBox()),
          ColoredBox(
            color: context.colorScheme.primary,
            child: SizedBox(height: 1, width: .infinity),
          ),
          // clear History Button
          Expanded(
            flex: 1,
            child: TextButton.icon(
              onPressed: () {}, // non functional
              icon: Icon(Icons.delete, color: context.colorScheme.error), //red
              label: Text(
                'CLEAR HISTORY',
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: .bold, // emphasize
                  color: context.colorScheme.error, // red
                ),
              ),
              style: TextButton.styleFrom(
                // expand to panel width
                minimumSize: const Size(.infinity, .infinity),
                // match card border radius
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:roastcalc/theme_extension.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: .circular(8),
      ),
      child: Column(
        children: [
          // TODO: Implement Scrollable list of past calculations
          Expanded(flex: 9, child: SizedBox()),
          Divider(height: 8, thickness: 2),
          // clear History Button
          Expanded(
            flex: 1,
            child: ElevatedButton.icon(
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

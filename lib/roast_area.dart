import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roastcalc/services/theme_extension.dart';
import '../services/roast_service.dart';

class RoastArea extends StatefulWidget {
  final List<String> history;

  const RoastArea({super.key, required this.history});

  @override
  State<RoastArea> createState() => _RoastAreaState();
}

class _RoastAreaState extends State<RoastArea> {
  final RoastService _roastService = RoastService();

  // Initial state
  String _currentRoast = "Initializing brainrot... 📉";
  List<String> _lastProcessedHistory = [];
  DateTime _lastRoastTime = DateTime.now();
  Timer? _checkTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 1. Initial Roast
    _triggerRoast();

    // 2. Periodic Check (Every 150 seconds)
    _checkTimer = Timer.periodic(const Duration(seconds: 150), (timer) {
      _checkConditionsAndRoast();
    });
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  void _checkConditionsAndRoast() {
    final now = DateTime.now();

    // condition A: history Changed
    bool historyChanged = !listEquals(widget.history, _lastProcessedHistory);

    // condition B: force Refresh (Every 5 mins) even if history is same
    bool forceRefresh = now.difference(_lastRoastTime).inMinutes >= 5;

    if (historyChanged || forceRefresh) {
      _triggerRoast();
    }
  }

  Future<void> _triggerRoast() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // fetch roast (service handles empty/offline/regular logic)
    String newRoast = await _roastService.getRoast(widget.history);

    setState(() {
      _currentRoast = newRoast;
      _lastProcessedHistory = List.from(widget.history);
      _lastRoastTime = DateTime.now();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: .symmetric(horizontal: 8),
        child: Row(
          children: [
            FittedBox(
              fit: .scaleDown,
              child: Text('🔥', style: context.textTheme.headlineLarge),
            ),
            const VerticalDivider(),
            Expanded(
              child: AnimatedSwitcher(
                // snappy 600ms total duration
                duration: const Duration(milliseconds: 600),

                // in: Starts halfway (300ms), ends at 600ms
                switchInCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),

                // out Starts at 0ms, ends halfway (300ms)
                switchOutCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),

                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },

                child: Text(
                  _currentRoast,
                  // ValueKey forces the animation to run when text changes
                  key: ValueKey<String>(_currentRoast),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/calculator_constants.dart';

class RoastPanel extends StatelessWidget {
  final String currentRoast;
  final VoidCallback onFireTapped;

  const RoastPanel({
    super.key,
    required this.currentRoast,
    required this.onFireTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: CalculatorConstants.gridPadding,
        vertical: CalculatorConstants.gridPadding / 2,
      ),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.primary,
          width: CalculatorConstants.borderWidth,
        ),
        borderRadius: BorderRadius.circular(CalculatorConstants.borderRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _AnimatedFireButton(onTap: onFireTapped),
          const SizedBox(width: 12.0),
          Expanded(
            child: AnimatedSwitcher(
              duration: CalculatorConstants.animPanel,
              switchInCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
              switchOutCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Container(
                key: ValueKey(currentRoast),
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  child: Text(
                    currentRoast,
                    textAlign: TextAlign.left,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14.0,
                      color: colorScheme.onSurface,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedFireButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AnimatedFireButton({required this.onTap});

  @override
  State<_AnimatedFireButton> createState() => _AnimatedFireButtonState();
}

class _AnimatedFireButtonState extends State<_AnimatedFireButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ), // Kept local: Specific to fire pulse
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          Icons.local_fire_department_outlined,
          color: colorScheme.primaryContainer,
          size: 24.0,
        ),
        onPressed: widget.onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 20.0,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const CalculatorButton({
    super.key,
    this.label,
    this.icon,
    required this.onTap,
    this.onLongPress,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = 28.0,
    this.fontWeight = FontWeight.normal,
  });

  Color _getDarkenedColor(Color color, [double amount = 0.15]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = _getDarkenedColor(backgroundColor);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          // Clean, zero-blur dynamic shadow for physical hardware depth
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 4),
              blurRadius: 0.0,
            ),
          ],
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: textColor, size: fontSize)
              : Text(
                  label ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: fontWeight,
                  ),
                ),
        ),
      ),
    );
  }
}

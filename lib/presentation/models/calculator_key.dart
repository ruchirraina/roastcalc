class CalculatorKey {
  final String label;
  final String value;
  final int col;
  final int row;
  final bool isExpandedOnly;

  const CalculatorKey({
    required this.label,
    required this.value,
    required this.col,
    required this.row,
    this.isExpandedOnly = false,
  });
}

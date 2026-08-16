class CalculatorKey {
  final String label;
  final String value;
  final int col;
  final int row;
  final bool isExpandedOnly;
  final int? historyCol;
  final int? historyRow;
  final bool isVisibleInHistory;

  const CalculatorKey({
    required this.label,
    required this.value,
    required this.col,
    required this.row,
    this.isExpandedOnly = false,
    this.historyCol,
    this.historyRow,
    this.isVisibleInHistory = false,
  });
}

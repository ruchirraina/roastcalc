class HistoryEntry {
  final String expression;
  final String answer;

  const HistoryEntry({required this.expression, required this.answer});

  Map<String, dynamic> toJson() => {'expression': expression, 'answer': answer};

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      expression: json['expression'] as String,
      answer: json['answer'] as String,
    );
  }
}

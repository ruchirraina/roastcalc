import 'package:flutter_test/flutter_test.dart';
import 'package:roastcalc/data/services/gemini_service.dart';
import 'package:roastcalc/domain/models/history_entry.dart';

void main() {
  test('GeminiService fetches roast from live Vercel proxy', () async {
    final service = GeminiService();
    final dummyHistory = [
      const HistoryEntry(expression: '2 + 2', answer: '4'),
      const HistoryEntry(expression: '100 / 0', answer: 'Undefined'),
    ];

    final result = await service.fetchRoast(dummyHistory);

    print('--- VERCEL ROAST TEST RESULT ---');
    print(result);
    print('--------------------------------');

    expect(result, isNotNull);
    expect(result!.isNotEmpty, isTrue);
  });
}

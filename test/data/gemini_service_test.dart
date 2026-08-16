import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roastcalc/data/services/gemini_service.dart';
import 'package:roastcalc/domain/models/history_entry.dart';

void main() {
  group('Vercel API Tests', () {
    final service = GeminiService();
    final dummyHistory = [
      const HistoryEntry(expression: '9 × 9', answer: '81'),
      const HistoryEntry(expression: '100 / 0', answer: 'Undefined'),
    ];

    test('Fetches roast from /api/roast', () async {
      final result = await service.fetchRoast(dummyHistory);
      debugPrint('--- ROAST RESULT ---');
      debugPrint(result);
      expect(result, isNotNull);
      expect(result.isNotEmpty, isTrue);
    });

    test('Fetches chips from /api/hacks', () async {
      final result = await service.fetchHackChips(dummyHistory);
      debugPrint('--- HACKS CHIPS RESULT ---');
      debugPrint(result?.toString());
      expect(result, isNotNull);
      expect(result!.length, 3);
    });

    test('Fetches explanation from /api/hacks', () async {
      final result = await service.fetchHackExplanation(
        dummyHistory,
        'The 9 multiplier trick',
      );
      debugPrint('--- HACKS EXPLANATION RESULT ---');
      debugPrint(result);
      expect(result, isNotNull);
      expect(result!.isNotEmpty, isTrue);
    });
  });
}

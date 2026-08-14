import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../domain/models/history_entry.dart';

class GeminiService {
  Future<String?> fetchRoast(List<HistoryEntry> history) async {
    if (history.isEmpty) return null;

    final String historyText = history
        .take(5)
        .map((e) => '${e.expression} = ${e.answer}')
        .join('\n');

    final String fullPrompt =
        '${ApiConstants.roastSystemPrompt}\n\nUser History:\n$historyText';

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.geminiEndpoint),
        headers: {
          'x-goog-api-key': ApiConstants.geminiApiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': fullPrompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic>? candidates = data['candidates'] as List<dynamic>?;

        if (candidates != null && candidates.isNotEmpty) {
          final Map<String, dynamic>? content =
              candidates[0]['content'] as Map<String, dynamic>?;
          final List<dynamic>? parts = content?['parts'] as List<dynamic>?;

          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] as String?;
          }
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

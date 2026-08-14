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

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.proxyEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'historyText': historyText}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['outputText'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

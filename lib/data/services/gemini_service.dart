import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/constants/roast_fallbacks.dart';
import '../../domain/models/history_entry.dart';

class GeminiService {
  final Random _random = Random();

  String _getRandom(List<String> list) => list[_random.nextInt(list.length)];

  Future<String> fetchRoast(List<HistoryEntry> history) async {
    if (history.isEmpty) {
      return _getRandom(RoastFallbacks.emptyHistory);
    }

    final String historyText = history
        .take(3)
        .map((e) => '${e.expression} = ${e.answer}')
        .join('\n');

    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.proxyEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'historyText': historyText}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final output = data['outputText'] as String?;
        if (output != null && output.isNotEmpty) {
          return output;
        }
      }
      return _getRandom(RoastFallbacks.serverError);
    } catch (_) {
      return _getRandom(RoastFallbacks.offline);
    }
  }

  Future<List<String>?> fetchHackChips(List<HistoryEntry> history) async {
    final String historyText = history.isEmpty
        ? 'empty'
        : history
              .take(5)
              .map((e) => '${e.expression} = ${e.answer}')
              .join('\n');

    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.hacksEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'historyText': historyText, 'action': 'chips'}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String? outputText = data['outputText'] as String?;
        if (outputText == null) return null;

        final List<dynamic> parsed = jsonDecode(outputText);
        return parsed.map((e) => e.toString()).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> fetchHackExplanation(
    List<HistoryEntry> history,
    String topic,
  ) async {
    final String historyText = history.isEmpty
        ? 'empty'
        : history
              .take(5)
              .map((e) => '${e.expression} = ${e.answer}')
              .join('\n');

    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.hacksEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'historyText': historyText,
              'action': 'explain',
              'topic': topic,
            }),
          )
          .timeout(const Duration(seconds: 10));

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

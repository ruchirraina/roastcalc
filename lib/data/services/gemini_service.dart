import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/constants/roast_fallbacks.dart';
import '../../domain/models/history_entry.dart';

class GeminiService {
  final Random _random = Random();

  String _getRandom(List<String> list) => list[_random.nextInt(list.length)];

  Future<String?> fetchRoast(List<HistoryEntry> history) async {
    if (history.isEmpty) {
      return _getRandom(RoastFallbacks.emptyHistory);
    }

    final String historyText = history
        .take(5)
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
        return data['outputText'] as String?;
      }

      return _getRandom(RoastFallbacks.serverError);
    } catch (_) {
      return _getRandom(RoastFallbacks.offline);
    }
  }
}

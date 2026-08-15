import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/constants/roast_fallbacks.dart';
import '../../domain/models/history_entry.dart';

class GeminiService {
  DateTime? _lastRequestTime;
  bool _isFirstLaunch = true;
  final Random _random = Random();

  String _getRandom(List<String> list) => list[_random.nextInt(list.length)];

  Future<String?> fetchRoast(
    List<HistoryEntry> history, {
    bool bypassCooldown = false,
  }) async {
    if (history.isEmpty) {
      return _getRandom(RoastFallbacks.emptyHistory);
    }

    final DateTime now = DateTime.now();

    if (!bypassCooldown) {
      if (_isFirstLaunch) {
        _isFirstLaunch = false;
        _lastRequestTime = now;
        return _getRandom(RoastFallbacks.greetings);
      }

      if (_lastRequestTime != null &&
          now.difference(_lastRequestTime!).inMinutes < 1) {
        return null;
      }
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
        _lastRequestTime = now;
        return data['outputText'] as String?;
      }

      return _getRandom(RoastFallbacks.serverError);
    } catch (_) {
      return _getRandom(RoastFallbacks.offline);
    }
  }
}

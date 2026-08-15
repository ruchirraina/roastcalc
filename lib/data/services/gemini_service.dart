import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../domain/models/history_entry.dart';

class GeminiService {
  DateTime? _lastRequestTime;
  bool _isFirstLaunch = true;

  Future<String?> fetchRoast(
    List<HistoryEntry> history, {
    bool bypassCooldown = false,
  }) async {
    if (history.isEmpty) {
      return "Do some math first. I can't judge an empty screen.";
    }

    final DateTime now = DateTime.now();

    if (!bypassCooldown) {
      if (_isFirstLaunch) {
        _isFirstLaunch = false;
        _lastRequestTime = now;
        return "Welcome to RoastCalc. Keep calculating, I'll start judging in about 5 minutes.";
      }

      if (_lastRequestTime != null &&
          now.difference(_lastRequestTime!).inMinutes < 5) {
        return "Still processing how bad your last calculations were. Give me a few minutes.";
      }
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
        _lastRequestTime = now;
        return data['outputText'] as String?;
      }

      return "I tried to roast you, but the server cringed too hard. Try again later.";
    } catch (_) {
      return "No internet? Don't worry, your math is still questionable offline.";
    }
  }
}

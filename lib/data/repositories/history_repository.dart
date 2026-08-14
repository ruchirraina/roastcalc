import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/history_entry.dart';

class HistoryRepository {
  static const String _storageKey = 'calculator_history';
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<void> saveHistory(List<HistoryEntry> history) async {
    final String encodedData = jsonEncode(
      history.map((entry) => entry.toJson()).toList(),
    );
    await _prefs.setString(_storageKey, encodedData);
  }

  Future<List<HistoryEntry>> loadHistory() async {
    final String? encodedData = await _prefs.getString(_storageKey);

    if (encodedData == null) return [];

    try {
      final List<dynamic> decodedList = jsonDecode(encodedData);
      return decodedList
          .map((item) => HistoryEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

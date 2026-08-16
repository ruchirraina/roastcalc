import 'package:shared_preferences/shared_preferences.dart';

class HacksRepository {
  static const String _timerKey = 'hacks_cooldown_timestamp';
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<void> startCooldown() async {
    await _prefs.setInt(_timerKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<int?> getCooldownTimestamp() async {
    return await _prefs.getInt(_timerKey);
  }

  Future<void> clearCooldown() async {
    await _prefs.remove(_timerKey);
  }
}

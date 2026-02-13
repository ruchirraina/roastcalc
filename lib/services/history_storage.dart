import 'package:shared_preferences/shared_preferences.dart';

class HistoryStorage {
  // SharedPreferences instance
  static SharedPreferences? _sharedPreferences;

  static const String _historyKey = 'historyKey';

  // get SharedPreferences instance
  static Future<void> init() async {
    // new instance if null - prevent multiple instances
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  // add to history expression and answer at its index
  static Future<void> addHistory({
    required List<String> expressionAnswerList,
  }) async {
    await _sharedPreferences?.setStringList(_historyKey, expressionAnswerList);
  }

  // get histroy expression and and answer
  static List<String> getHistory() {
    return _sharedPreferences?.getStringList(_historyKey) ?? [];
  }
}

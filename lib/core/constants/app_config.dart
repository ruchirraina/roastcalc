class AppConfig {
  // Networking
  static const Duration apiTimeout = Duration(seconds: 10);

  // Timers & Delays
  static const Duration roastInterval = Duration(minutes: 1);
  static const Duration hacksCooldown = Duration(minutes: 5);
  static const Duration minimumLoadingDelay = Duration(milliseconds: 500);

  // Data Limits
  static const int maxHistoryEntries = 15;
  static const int roastHistoryCount = 3;
  static const int hacksHistoryCount = 5;

  // Math Precision
  static const double mathPrecisionFactor = 10000000000.0;
}

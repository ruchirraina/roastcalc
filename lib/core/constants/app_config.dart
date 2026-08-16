class AppConfig {
  // Networking
  static const Duration apiTimeout = Duration(seconds: 10);

  // Timers & Delays
  static const Duration roastInterval = Duration(seconds: 30);
  static const Duration hacksCooldown = Duration(minutes: 2);
  static const Duration minimumLoadingDelay = Duration(milliseconds: 500);

  // Data Limits
  static const int maxHistoryEntries = 15;
  static const int roastHistoryCount = 5;
  static const int hacksHistoryCount = 10;

  // Math Precision
  static const double mathPrecisionFactor = 10000000000.0;
}

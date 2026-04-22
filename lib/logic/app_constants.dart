class AppConstants {
  const AppConstants._();

  static const double wheelSize = 320;
  static const double pointerWidth = 34;
  static const double pointerHeight = 28;
  static const double shakeHintThreshold = 4.8;
  static const double shakeWarmThreshold = 7.0;
  static const double shakeThreshold = 8.8;
  static const Duration shakeCooldown = Duration(milliseconds: 1500);
  static const Duration shakeFeedbackThrottle = Duration(milliseconds: 220);
  static const int minTurns = 3;
  static const int maxTurns = 10;
  static const Duration minSpinDuration = Duration(milliseconds: 1600);
  static const Duration maxSpinDuration = Duration(milliseconds: 6200);
}

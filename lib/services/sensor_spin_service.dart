import 'dart:async';
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

import '../logic/app_constants.dart';
import '../logic/wheel_math.dart';

class SensorFeedback {
  const SensorFeedback({required this.message, required this.intensity});

  final String message;
  final double intensity;
}

class SensorSpinService {
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  DateTime _lastTrigger = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastFeedback = DateTime.fromMillisecondsSinceEpoch(0);
  double _smoothedMagnitude = 0;
  String? _lastFeedbackMessage;

  void start({
    required void Function(SpinInput input) onTrigger,
    void Function(SensorFeedback feedback)? onFeedback,
  }) {
    _subscription ??= userAccelerometerEventStream().listen((event) {
      final double rawMagnitude = math.sqrt(
        (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
      );
      _smoothedMagnitude = (_smoothedMagnitude * 0.72) + (rawMagnitude * 0.28);
      final double magnitude = math.max(rawMagnitude, _smoothedMagnitude);
      final DateTime now = DateTime.now();
      final bool coolingDown =
          now.difference(_lastTrigger) < AppConstants.shakeCooldown;

      if (!coolingDown) {
        final SensorFeedback? feedback = _buildFeedback(
          magnitude: magnitude,
          now: now,
        );
        if (feedback != null) {
          _lastFeedback = now;
          _lastFeedbackMessage = feedback.message;
          onFeedback?.call(feedback);
        }
      }

      if (coolingDown || magnitude < AppConstants.shakeThreshold) {
        return;
      }

      _lastTrigger = now;
      _lastFeedbackMessage = null;
      final double normalized = ((magnitude - AppConstants.shakeThreshold) / 8)
          .clamp(0.0, 1.0);
      onTrigger(
        SpinInput(
          intensity: 0.6 + (normalized * 0.4),
          sourceLabel: '\u4f20\u611f\u5668\u89e6\u53d1',
        ),
      );
    });
  }

  SensorFeedback? _buildFeedback({
    required double magnitude,
    required DateTime now,
  }) {
    if (now.difference(_lastFeedback) < AppConstants.shakeFeedbackThrottle) {
      return null;
    }

    if (magnitude >= AppConstants.shakeWarmThreshold) {
      return _distinctFeedback(
        message: '\u5feb\u89e6\u53d1\u4e86\uff0c\u518d\u52a0\u4e00\u70b9',
        intensity: (magnitude / AppConstants.shakeThreshold).clamp(0.0, 1.0),
      );
    }

    if (magnitude >= AppConstants.shakeHintThreshold) {
      return _distinctFeedback(
        message:
            '\u52a8\u4f5c\u6536\u5230\u4e86\uff0c\u518d\u7529\u5927\u4e00\u70b9',
        intensity: (magnitude / AppConstants.shakeWarmThreshold).clamp(
          0.0,
          1.0,
        ),
      );
    }

    if (_lastFeedbackMessage != null &&
        magnitude < (AppConstants.shakeHintThreshold * 0.5)) {
      return _distinctFeedback(
        message:
            '\u70b9\u51fb\u6309\u94ae\uff0c\u6216\u8f7b\u5feb\u5730\u7529\u52a8\u624b\u673a',
        intensity: 0,
      );
    }

    return null;
  }

  SensorFeedback? _distinctFeedback({
    required String message,
    required double intensity,
  }) {
    if (_lastFeedbackMessage == message) {
      return null;
    }

    return SensorFeedback(message: message, intensity: intensity);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}

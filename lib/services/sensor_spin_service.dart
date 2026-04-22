import 'dart:async';
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

import '../logic/app_constants.dart';
import '../logic/wheel_math.dart';

class SensorSpinService {
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  DateTime _lastTrigger = DateTime.fromMillisecondsSinceEpoch(0);

  void start({required void Function(SpinInput input) onTrigger}) {
    _subscription ??= userAccelerometerEventStream().listen((event) {
      final double magnitude = math.sqrt(
        (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
      );
      final DateTime now = DateTime.now();
      final bool coolingDown =
          now.difference(_lastTrigger) < AppConstants.shakeCooldown;

      if (coolingDown || magnitude < AppConstants.shakeThreshold) {
        return;
      }

      _lastTrigger = now;
      final double normalized = ((magnitude - AppConstants.shakeThreshold) / 12)
          .clamp(0.0, 1.0);
      onTrigger(
        SpinInput(
          intensity: 0.65 + (normalized * 0.35),
          sourceLabel: '\u4f20\u611f\u5668\u89e6\u53d1',
        ),
      );
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}

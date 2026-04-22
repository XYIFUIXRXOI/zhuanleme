import 'dart:math' as math;

import '../models/wheel_data.dart';

class SpinInput {
  const SpinInput({required this.intensity, required this.sourceLabel});

  final double intensity;
  final String sourceLabel;
}

class SpinPlan {
  const SpinPlan({
    required this.targetAngle,
    required this.overshootAngle,
    required this.direction,
    required this.selectedIndex,
    required this.initialVelocity,
    required this.totalRotation,
    required this.duration,
    required this.sourceLabel,
  });

  final double targetAngle;
  final double overshootAngle;
  final int direction;
  final int selectedIndex;
  final double initialVelocity;
  final double totalRotation;
  final Duration duration;
  final String sourceLabel;
}

class WheelMath {
  const WheelMath._();

  static const double _twoPi = math.pi * 2;
  static final math.Random _random = math.Random();

  static SpinPlan buildSpinPlan({
    required WheelData data,
    required double currentAngle,
    required SpinInput input,
    required int minTurns,
    required int maxTurns,
    required Duration minDuration,
    required Duration maxDuration,
  }) {
    final int selectedIndex = _weightedIndex(data);
    final int direction = _random.nextBool() ? 1 : -1;
    final double normalizedIntensity = input.intensity.clamp(0.0, 1.0);
    final int turns =
        minTurns +
        ((maxTurns - minTurns) * normalizedIntensity).round().clamp(
          0,
          maxTurns,
        );
    final double sectorAngle = _twoPi / data.options.length;
    final double targetSliceCenter = _centerAngleForIndex(
      selectedIndex,
      sectorAngle,
    );
    final double normalizedCurrent = _normalizeAngle(currentAngle);

    // We always land on the center of a slice, then add full turns so the
    // result feels driven by momentum instead of a flat random jump.
    final double correction = direction == 1
        ? _positiveModulo(targetSliceCenter - normalizedCurrent, _twoPi)
        : -_positiveModulo(normalizedCurrent - targetSliceCenter, _twoPi);

    final double totalRotation = (turns * _twoPi * direction) + correction;
    final double targetAngle = currentAngle + totalRotation;
    final double overshootAngle =
        targetAngle + (direction * sectorAngle * 0.08);
    final int durationDeltaMs =
        (maxDuration.inMilliseconds - minDuration.inMilliseconds);
    final int durationMs =
        minDuration.inMilliseconds +
        (durationDeltaMs * normalizedIntensity).round();
    final double initialVelocity =
        totalRotation.abs() / (durationMs / 1000).clamp(0.001, double.infinity);

    return SpinPlan(
      targetAngle: targetAngle,
      overshootAngle: overshootAngle,
      direction: direction,
      selectedIndex: selectedIndex,
      initialVelocity: initialVelocity,
      totalRotation: totalRotation,
      duration: Duration(milliseconds: durationMs),
      sourceLabel: input.sourceLabel,
    );
  }

  static int resolveIndexFromAngle({
    required double angle,
    required int itemCount,
  }) {
    final double sectorAngle = _twoPi / itemCount;
    final double normalized = _normalizeAngle(angle);
    // The pointer is fixed at the top, so we invert the wheel angle first and
    // then map the aligned angle into an item index.
    final double pointerAligned = _positiveModulo(_twoPi - normalized, _twoPi);
    final int index = (pointerAligned / sectorAngle).floor() % itemCount;
    return index;
  }

  static double _centerAngleForIndex(int index, double sectorAngle) {
    return _positiveModulo(_twoPi - ((index + 0.5) * sectorAngle), _twoPi);
  }

  static int _weightedIndex(WheelData data) {
    final double totalWeight = data.options.fold<double>(
      0,
      (double sum, option) => sum + option.weight,
    );
    double ticket = _random.nextDouble() * totalWeight;

    for (int i = 0; i < data.options.length; i++) {
      ticket -= data.options[i].weight;
      if (ticket <= 0) {
        return i;
      }
    }

    return data.options.length - 1;
  }

  static double _normalizeAngle(double angle) {
    return _positiveModulo(angle, _twoPi);
  }

  static double _positiveModulo(double value, double modulo) {
    return ((value % modulo) + modulo) % modulo;
  }
}

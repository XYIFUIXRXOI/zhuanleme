import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/wheel_data.dart';
import '../theme/app_colors.dart';

class WheelPainter extends CustomPainter {
  const WheelPainter({required this.data});

  final WheelData data;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final double sweep = (math.pi * 2) / data.options.length;

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xCCFFFFFF), Color(0x667B61FF)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final Paint innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = AppColors.white38;

    for (int i = 0; i < data.options.length; i++) {
      final double startAngle = (-math.pi / 2) + (i * sweep);
      final Path slice = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(rect, startAngle, sweep, false)
        ..close();

      final Paint fill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.options[i].color,
        ).createShader(rect);

      canvas.drawShadow(
        slice,
        data.options[i].color.last.withValues(alpha: 0.55),
        14,
        false,
      );
      canvas.drawPath(slice, fill);

      final Paint divider = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = AppColors.white38;
      canvas.drawPath(slice, divider);

      _paintLabel(
        canvas: canvas,
        center: center,
        radius: radius,
        startAngle: startAngle,
        sweep: sweep,
        text: data.options[i].title,
      );
    }

    canvas.drawCircle(center, radius - 4, borderPaint);
    canvas.drawCircle(center, radius * 0.18, innerRingPaint);
    canvas.drawCircle(
      center,
      radius * 0.12,
      Paint()
        ..shader = const LinearGradient(
          colors: <Color>[Color(0xFFFFFFFF), Color(0xFF7B61FF)],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 0.12)),
    );
  }

  void _paintLabel({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweep,
    required String text,
  }) {
    final double angle = startAngle + (sweep / 2);
    final double labelRadius = radius * 0.64;
    final Offset labelCenter = Offset(
      center.dx + (math.cos(angle) * labelRadius),
      center.dy + (math.sin(angle) * labelRadius),
    );

    canvas.save();
    canvas.translate(labelCenter.dx, labelCenter.dy);
    canvas.rotate(angle + (math.pi / 2));

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: radius * 0.34);

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

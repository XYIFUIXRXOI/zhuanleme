import 'package:flutter/material.dart';

import '../logic/app_constants.dart';
import '../theme/app_colors.dart';

class WheelPointer extends StatelessWidget {
  const WheelPointer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.pointerWidth,
      height: AppConstants.pointerHeight,
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.pointerGlow,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomPaint(painter: _PointerPainter()),
    );
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    final Paint fill = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFFFFD200), Color(0xFFFF8F5A)],
      ).createShader(Offset.zero & size);

    canvas.drawPath(path, fill);

    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = AppColors.white70;

    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

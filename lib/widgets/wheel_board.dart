import 'package:flutter/material.dart';

import '../logic/app_constants.dart';
import '../models/wheel_data.dart';
import '../theme/app_colors.dart';
import 'wheel_painter.dart';
import 'wheel_pointer.dart';

class WheelBoard extends StatelessWidget {
  const WheelBoard({super.key, required this.data, required this.angle});

  final WheelData data;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.wheelSize,
      height: AppConstants.wheelSize + 48,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            top: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: AppColors.edgeGlow,
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Transform.rotate(
                angle: angle,
                child: CustomPaint(
                  size: const Size.square(AppConstants.wheelSize),
                  painter: WheelPainter(data: data),
                ),
              ),
            ),
          ),
          const Positioned(top: 0, child: WheelPointer()),
        ],
      ),
    );
  }
}

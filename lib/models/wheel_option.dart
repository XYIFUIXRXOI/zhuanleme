import 'package:flutter/material.dart';

class WheelOption {
  const WheelOption({
    required this.title,
    required this.color,
    required this.weight,
  });

  final String title;
  final List<Color> color;
  final double weight;
}

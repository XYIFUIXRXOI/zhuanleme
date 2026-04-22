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

  WheelOption copyWith({String? title, List<Color>? color, double? weight}) {
    return WheelOption(
      title: title ?? this.title,
      color: color ?? this.color,
      weight: weight ?? this.weight,
    );
  }
}

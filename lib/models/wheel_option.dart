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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'color': color.map((Color item) => item.toARGB32()).toList(),
      'weight': weight,
    };
  }

  factory WheelOption.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawColors =
        json['color'] as List<dynamic>? ?? <dynamic>[];

    return WheelOption(
      title: json['title'] as String? ?? '',
      color: rawColors
          .map((dynamic item) => Color(item as int))
          .toList(growable: false),
      weight: (json['weight'] as num?)?.toDouble() ?? 1,
    );
  }
}

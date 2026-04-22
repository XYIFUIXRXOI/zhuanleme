import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color backgroundTop = Color(0xFF0F0F1A);
  static const Color backgroundBottom = Color(0xFF151528);
  static const Color surface = Color(0xFF1A1C32);
  static const Color surfaceMuted = Color(0xFF212442);
  static const Color white = Colors.white;
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white38 = Color(0x61FFFFFF);
  static const Color pointerGlow = Color(0x66FFD200);
  static const Color edgeGlow = Color(0x667B61FF);
  static const Color buttonGlow = Color(0x664FACFE);

  static const List<List<Color>> wheelGradients = <List<Color>>[
    <Color>[Color(0xFF7B61FF), Color(0xFFFF6FD8)],
    <Color>[Color(0xFF4FACFE), Color(0xFF00F2FE)],
    <Color>[Color(0xFFF7971E), Color(0xFFFFD200)],
    <Color>[Color(0xFF43E97B), Color(0xFF38F9D7)],
  ];
}

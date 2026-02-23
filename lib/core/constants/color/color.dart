import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static List<Color> get SHADOWS => [
    Colors.black.withOpacity(.8),
    Colors.black.withOpacity(.0),
  ];

  static Color get SHADOW => Colors.black.withOpacity(.25);
  static Color get NAVIGATION => Color(0xFF2E2E30);
  static Color get GREEN => Color(0xFF34C759);
  static Color get YELLOW => Color(0xFFFFAB00);
  static Color get ORANGE => Color(0xFFFF7600);

  // Camera page colors
  static const Color BLACK = Colors.black;
  static const Color WHITE = Colors.white;
  static const Color TRANSPARENT = Colors.transparent;
  static const Color RED_ACCENT = Colors.redAccent;
  static Color get WHITE_15 => Colors.white.withOpacity(0.15);
  static Color get WHITE_20 => Colors.white.withOpacity(0.20);
  static Color get WHITE_50 => Colors.white.withOpacity(0.50);
  static const Color WHITE_30 = Colors.white30;
  static const Color WHITE_54 = Colors.white54;
  static Color get BLACK_30 => Colors.black.withOpacity(0.3);
  static Color get BLACK_70 => Colors.black.withOpacity(0.7);
  static Color get BLACK_80 => Colors.black.withOpacity(0.8);
}

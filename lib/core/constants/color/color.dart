import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static List<Color> get SHADOWS => [
    Colors.black.withOpacity(.8),
    Colors.black.withOpacity(.0),
  ];

  static Color get SHADOW => Colors.black.withOpacity(.25);
  static Color get NAVIGATION => Color(0xFF2E2E30);
}

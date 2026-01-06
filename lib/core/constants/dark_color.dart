import 'package:flutter/material.dart';

class AppDarkColors {
  AppDarkColors._();

  static Color get PRIMARY => Colors.white;
  static Color get SECONDARY => Color(0xFF0E0E0E);

  static Color get WHITE75 => Colors.white.withOpacity(.75);
  static Color get WHITE60 => Colors.white.withOpacity(.60);
  static Color get WHITE50 => Colors.white.withOpacity(.50);
  static Color get WHITE32 => Colors.white.withOpacity(.32);
  static Color get WHITE16 => Colors.white.withOpacity(.16);

  static Color get YELLOW => Color(0xFFFFAB00);
  static Color get ORANGE => Color(0xFFFF7600);
  static Color get GREEN => Color(0xFF22C55E);
  static Color get GREY => Color(0xFF9E9E9E);
  static Color get DARK_GREY => Color(0xFFB9B9B9);
  static Color get RED => Color(0xFFEF4444);

  static Color get TRANSPARENT_GREEN => Color(0xFF0C1F13);
  static Color get TRANSPARENT_RED => Color(0xFF251010);
  static Color get TRANSPARENT_PURPLE => Color(0xFF1C1226);
  static Color get TRANSPARENT_BLUE => Color(0xFF101726);
  static Color get TRANSPARENT_YELLOW => Color(0xFF2C2C1E);

  static List<Color> get BUTTON => [YELLOW, ORANGE];
  static Color get DARK_BUTTON => Color(0xFF2E2E30);
  static Color get INACTIVE => Color(0xFF1C1B1B);
}

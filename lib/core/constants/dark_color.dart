import 'package:flutter/material.dart';

class AppDarkColors {
  AppDarkColors._();

  static Color get PRIMARY => AppDarkColors.PRIMARY;
  static Color get SECONDARY => Color(0xFF0E0E0E);

  static Color get WHITE75 => AppDarkColors.PRIMARY.withOpacity(.75);
  static Color get WHITE60 => AppDarkColors.PRIMARY.withOpacity(.60);
  static Color get WHITE50 => AppDarkColors.PRIMARY.withOpacity(.50);
  static Color get WHITE32 => AppDarkColors.PRIMARY.withOpacity(.32);
  static Color get WHITE16 => AppDarkColors.PRIMARY.withOpacity(.16);
  static Color get WHITE08 => AppDarkColors.PRIMARY.withOpacity(.08);

  static Color get GREY12 => Color(0xFFD9D9D9).withOpacity(.12);
  static Color get GREY24 => Color(0xFFD9D9D9).withOpacity(.24);
  static Color get GREY36 => Color(0xFFD9D9D9).withOpacity(.36);

  static Color get YELLOW => Color(0xFFFFAB00);
  static Color get ORANGE => Color(0xFFFF7600);
  static Color get GREEN => Color(0xFF22C55E);
  static Color get GREY => Color(0xFF9E9E9E);
  static Color get DARK_GREY => Color(0xFFB9B9B9);
  static Color get RED => Color(0xFFEF4444);
  static Color get BLUE => Color(0xFF3B82F6);
  static Color get PURPLE => Color(0xFFA855F7);

  static Color get TRANSPARENT_GREEN => Color(0xFF0C1F13);
  static Color get TRANSPARENT_RED => Color(0xFF251010);
  static Color get TRANSPARENT_PURPLE => Color(0xFF1C1226);
  static Color get TRANSPARENT_BLUE => Color(0xFF101726);
  static Color get TRANSPARENT_YELLOW => Color(0xFF2C2C1E);

  static List<Color> get BUTTON => [YELLOW, ORANGE];
  static List<Color> get SHADOW => [
    SECONDARY.withOpacity(.8),
    SECONDARY.withOpacity(.0),
  ];
  static Color get DARK_BUTTON => Color(0xFF2E2E30);
  static Color get INACTIVE => Color(0xFF1C1B1B);
}

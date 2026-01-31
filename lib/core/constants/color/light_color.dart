import 'package:flutter/material.dart';

class LightColors {
  LightColors._();

  static Color get PRIMARY => Color(0xFF0E0E0E);
  static Color get SECONDARY => Color(0xFFFFFDF8);

  static Color get WHITE75 => LightColors.PRIMARY.withOpacity(.75);
  static Color get WHITE60 => LightColors.PRIMARY.withOpacity(.60);
  static Color get WHITE50 => LightColors.PRIMARY.withOpacity(.50);
  static Color get WHITE32 => LightColors.PRIMARY.withOpacity(.32);
  static Color get WHITE16 => LightColors.PRIMARY.withOpacity(.16);
  static Color get WHITE08 => LightColors.PRIMARY.withOpacity(.08);

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

  static Color get TRANSPARENT_GREEN => Color(0xFFECFFF3);
  static Color get TRANSPARENT_RED => Color(0xFFFFE4E4);
  static Color get TRANSPARENT_PURPLE => Color(0xFFF4E9FF);
  static Color get TRANSPARENT_BLUE => Color(0xFFEBF2FF);
  static Color get TRANSPARENT_YELLOW => Color(0xFFFBFCE6);

  static Color get DARK_BUTTON => Color(0xFF2E2E30);
  static Color get INACTIVE => Color(0xFF1C1B1B);
  static Color get NOTIFICATION => Color(0xFFEEEEEE);

  static Color get DISLIKE => Color(0xFFF0F0F0);
}

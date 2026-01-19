import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/dark_color.dart';
import 'package:rightflair/core/constants/font/font_family.dart';

import 'color/light_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: false,
    fontFamily: FontFamilyConstants.POPPINS,

    colorScheme: ColorScheme.dark(
      primary: LightColors.PRIMARY,
      primaryContainer: LightColors.WHITE75,
      onPrimary: LightColors.WHITE60,
      primaryFixed: LightColors.WHITE50,
      onPrimaryFixed: LightColors.WHITE32,
      primaryFixedDim: LightColors.WHITE16,
      onPrimaryContainer: LightColors.WHITE08,

      secondary: LightColors.SECONDARY,

      tertiary: LightColors.GREY,
      onTertiary: LightColors.DARK_GREY,
      tertiaryContainer: LightColors.GREY36,
      tertiaryFixed: LightColors.GREY24,
      tertiaryFixedDim: LightColors.GREY12,

      scrim: LightColors.ORANGE,

      surface: LightColors.YELLOW,
      onSurface: LightColors.TRANSPARENT_YELLOW,

      inverseSurface: LightColors.GREEN,
      onInverseSurface: LightColors.TRANSPARENT_GREEN,

      error: LightColors.RED,
      onError: LightColors.TRANSPARENT_RED,
      secondaryContainer: LightColors.PURPLE,
      onSecondaryContainer: LightColors.TRANSPARENT_PURPLE,

      surfaceVariant: LightColors.BLUE,
      onSurfaceVariant: LightColors.TRANSPARENT_BLUE,

      outline: LightColors.NOTIFICATION,
      shadow: Colors.white,

      onBackground: Colors.white,
      onSecondary: LightColors.NOTIFICATION,

      secondaryFixed: Colors.grey.shade300,
      onSecondaryFixed: Colors.grey.shade700,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: false,
    fontFamily: FontFamilyConstants.POPPINS,
    colorScheme: ColorScheme.dark(
      primary: DarkColors.PRIMARY,
      primaryContainer: DarkColors.WHITE75,
      onPrimary: DarkColors.WHITE60,
      primaryFixed: DarkColors.WHITE50,
      onPrimaryFixed: DarkColors.WHITE32,
      primaryFixedDim: DarkColors.WHITE16,
      onPrimaryContainer: DarkColors.WHITE08,

      secondary: DarkColors.SECONDARY,

      tertiary: DarkColors.GREY,
      onTertiary: DarkColors.DARK_GREY,
      tertiaryContainer: DarkColors.GREY36,
      tertiaryFixed: DarkColors.GREY24,
      tertiaryFixedDim: DarkColors.GREY12,

      scrim: DarkColors.ORANGE,

      surface: DarkColors.YELLOW,
      onSurface: DarkColors.TRANSPARENT_YELLOW,

      inverseSurface: DarkColors.GREEN,
      onInverseSurface: DarkColors.TRANSPARENT_GREEN,

      error: DarkColors.RED,
      onError: DarkColors.TRANSPARENT_RED,

      secondaryContainer: DarkColors.PURPLE,
      onSecondaryContainer: DarkColors.TRANSPARENT_PURPLE,

      surfaceVariant: DarkColors.BLUE,
      onSurfaceVariant: DarkColors.TRANSPARENT_BLUE,

      outline: DarkColors.DARK_BUTTON,
      shadow: DarkColors.INACTIVE,

      onBackground: DarkColors.INACTIVE,
      onSecondary: Color(0xFFD9D9D9).withOpacity(.12),


      secondaryFixed: Colors.grey.shade700,
      onSecondaryFixed: Colors.grey.shade300,
    ),
  );
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/config/config.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/core/constants/locale.dart';
import 'package:rightflair/core/services/messaging.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Config().init();

  await FirebaseMessagingManager().initialize();

  final ThemeMode themeMode = await _getThemeMode();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(themeMode),
      child: EasyLocalization(
        supportedLocales: LocaleEnum.values.map((e) => e.locale).toList(),
        path: AppConstants.PATH_LOCALIZATION,
        fallbackLocale: LocaleEnum.en.locale,
        child: const RightFlair(),
      ),
    ),
  );
}

Future<ThemeMode> _getThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final themeModeString = prefs.getString('themeMode') ?? 'system';

  switch (themeModeString) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

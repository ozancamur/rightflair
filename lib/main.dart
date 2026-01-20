import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/config/database_initialize.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/core/constants/locale.dart';
import 'package:rightflair/core/cloud/firebase/messaging.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await DatabaseInitialize().init();

  await FirebaseMessagingManager().initialize();

  final bool isDarkMode = await _isDarkMode();

  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          ThemeNotifier(isDarkMode ? ThemeMode.dark : ThemeMode.light),
      child: EasyLocalization(
        supportedLocales: LocaleEnum.values.map((e) => e.locale).toList(),
        path: AppConstants.PATH_LOCALIZATION,
        fallbackLocale: LocaleEnum.en.locale,
        child: const RightFlair(),
      ),
    ),
  );
}

Future<bool> _isDarkMode() async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? true;
  return isDarkMode;
}

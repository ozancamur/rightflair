import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/core/constants/locale.dart';
import 'package:rightflair/core/firebase/messaging.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  await FirebaseMessagingManager().initialize();

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

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    _saveTheme(_themeMode);
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(_themeMode);
    notifyListeners();
  }
}

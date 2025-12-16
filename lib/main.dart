import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/app.dart';
import 'package:rightflair/core/constants/locale.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: LocaleEnum.values.map((e) => e.locale).toList(),
      path: AppConstants.pathLocalization,
      fallbackLocale: LocaleEnum.en.locale,
      child: const RightFlair(),
    ),
  );
}

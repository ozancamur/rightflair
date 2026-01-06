import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/font_family.dart';
import 'package:rightflair/core/utils/router.dart';

class RightFlair extends StatelessWidget {
  const RightFlair({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RightFlair',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      theme: ThemeData(
        fontFamily: FontFamilyConstants.POPPINS,
        useMaterial3: false,
      ),
      locale: context.locale,
    );
  }
}

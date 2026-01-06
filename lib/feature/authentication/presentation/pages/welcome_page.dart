import 'package:flutter/material.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/constants/dark_color.dart';
import '../widgets/welcome/welcome_buttons.dart';
import '../widgets/authentication_have_account.dart';
import '../widgets/welcome/welcome_logo.dart';
import '../widgets/welcome/welcome_title.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDarkColors.SECONDARY,
      body: SafeArea(
        child: SizedBox(
          height: context.height,
          width: context.width,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: context.height * .015,
      children: [
        SizedBox(height: context.height * .005),
        const WelcomeLogoWidget(),
        const WelcomeTitleWidget(),
        WelcomeButtonsWidget(),
        Spacer(),
        AuthenticationHaveAccountWidget(),
      ],
    );
  }
}

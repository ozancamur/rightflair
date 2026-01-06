import 'package:flutter/material.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../core/constants/dark_color.dart';
import '../../../../core/extensions/context.dart';
import '../widgets/authentication_text.dart';
import '../widgets/login/login_button.dart';
import '../widgets/login/login_forgot_password.dart';
import '../widgets/login/login_inputs.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDarkColors.SECONDARY,
      appBar: AppBarComponent(title: AppStrings.LOGIN),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * .05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: context.height * .005,
        children: [
          const AuthenticationTextWidget(
            title: AppStrings.LOGIN_TITLE,
            subtitle: AppStrings.LOGIN_SUBTITLE,
          ),
          const LoginInputsWidget(),
          SizedBox(height: context.height * .025),
          const LoginButtonWidget(),
          const LoginForgotPasswordWidget(),
        ],
      ),
    );
  }
}

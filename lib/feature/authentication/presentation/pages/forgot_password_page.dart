import 'package:flutter/material.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../core/constants/dark_color.dart';
import '../../../../core/extensions/context.dart';
import '../widgets/authentication_text.dart';
import '../widgets/forgot_password/forgot_password_button.dart';
import '../widgets/forgot_password/forgot_password_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDarkColors.SECONDARY,
      appBar: AppBarComponent(title: AppStrings.FORGOT_PASSWORD_APPBAR),
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
            title: AppStrings.FORGOT_PASSWORD_TITLE,
            subtitle: AppStrings.FORGOT_PASSWORD_SUBTITLE,
          ),
          const ForgotPasswordTextField(),
          SizedBox(height: context.height * .025),
          const ForgotPasswordButton(),
        ],
      ),
    );
  }
}

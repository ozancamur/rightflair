import 'package:flutter/material.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../core/constants/dark_color.dart';
import '../../../../core/extensions/context.dart';
import '../widgets/authentication_have_account.dart';
import '../widgets/authentication_text.dart';
import '../widgets/register/register_button.dart';
import '../widgets/register/register_inputs.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDarkColors.SECONDARY,
      appBar: AppBarComponent(title: AppStrings.REGISTER_APPBAR),
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
            title: AppStrings.REGISTER_TITLE,
            subtitle: AppStrings.REGISTER_SUBTITLE,
          ),
          const RegisterInputsWidget(),
          SizedBox(height: context.height * .025),
          const RegisterButtonWidget(),
          const AuthenticationHaveAccountWidget(),
        ],
      ),
    );
  }
}

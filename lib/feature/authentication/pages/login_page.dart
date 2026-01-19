import 'package:flutter/material.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/back_button.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/extensions/context.dart';
import '../widgets/authentication_text.dart';
import '../widgets/login/login_button.dart';
import '../widgets/login/login_forgot_password.dart';
import '../widgets/login/login_inputs.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> keyLogin = GlobalKey<FormState>();
  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBarComponent(
        leading: BackButtonComponent(),
        title: AppStrings.LOGIN,
      ),
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
          LoginInputsWidget(
            formKey: keyLogin,
            ctrlEmail: ctrlEmail,
            ctrlPassword: ctrlPassword,
          ),
          SizedBox(height: context.height * .025),
          const LoginButtonWidget(),
          const LoginForgotPasswordWidget(),
        ],
      ),
    );
  }
}

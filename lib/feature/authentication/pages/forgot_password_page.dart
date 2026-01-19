import 'package:flutter/material.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/back_button.dart';
import '../../../core/extensions/context.dart';
import '../widgets/authentication_text.dart';
import '../widgets/forgot_password/forgot_password_button.dart';
import '../widgets/forgot_password/forgot_password_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final GlobalKey<FormState> keyForgotPassword = GlobalKey<FormState>();
  final TextEditingController ctrlEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBarComponent(
        leading: BackButtonComponent(),
        title: AppStrings.FORGOT_PASSWORD_APPBAR,
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
            title: AppStrings.FORGOT_PASSWORD_TITLE,
            subtitle: AppStrings.FORGOT_PASSWORD_SUBTITLE,
          ),
          ForgotPasswordTextField(
            formKey: keyForgotPassword,
            controller: ctrlEmail,
          ),
          SizedBox(height: context.height * .025),
          const ForgotPasswordButton(),
        ],
      ),
    );
  }
}

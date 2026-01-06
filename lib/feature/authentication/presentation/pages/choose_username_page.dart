import 'package:flutter/material.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../core/constants/dark_color.dart';
import '../../../../core/extensions/context.dart';
import '../widgets/authentication_text.dart';
import '../widgets/choose_username/choose_username_button.dart';
import '../widgets/choose_username/choose_username_textfield.dart';
import '../widgets/choose_username/choose_username_validation.dart';

class ChooseUsernamePage extends StatelessWidget {
  const ChooseUsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDarkColors.SECONDARY,
      appBar: AppBarComponent(title: AppStrings.CHOOSE_USERNAME_APPBAR),
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
            title: AppStrings.CHOOSE_USERNAME_TITLE,
            subtitle: AppStrings.CHOOSE_USERNAME_SUBTITLE,
          ),
          ChooseUsernameTextField(isValid: false, username: "ozancamur"),
          ChooseUsernameValidationWidget(
            isUnique: false,
            isCaseInsensitive: true,
          ),
          SizedBox(height: context.height * .025),
          const ChooseUsernameButtonWidget(),
        ],
      ),
    );
  }
}

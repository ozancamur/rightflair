import 'package:flutter/material.dart';

import '../../../../../core/components/password_text_field.dart';
import '../../../../../core/components/text_field.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';

class LoginInputsWidget extends StatelessWidget {
  const LoginInputsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * .01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * .015,
        children: [
          TextFieldComponent(
            controller: TextEditingController(),
            hintText: AppStrings.EMAIL,
            regExp: RegExp(''),
            errorText: "",
          ),
          PasswordTextFieldComponent(
            controller: TextEditingController(),
            hintText: AppStrings.PASSWORD,
            regExp: RegExp(''),
            errorText: "",
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';

import '../../../../../core/components/password_text_field.dart';
import '../../../../../core/components/text_field.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';

class RegisterInputsWidget extends StatelessWidget {
  const RegisterInputsWidget({super.key});

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
          PasswordTextFieldComponent(
            controller: TextEditingController(),
            hintText: AppStrings.CONFIRM_PASSWORD,
            regExp: RegExp(''),
            errorText: "",
          ),
          Padding(
            padding: EdgeInsets.only(left: context.width * .05),
            child: TextComponent(
              text: AppStrings.REGISTER_PASSWORD,
              color: AppDarkColors.WHITE60,
              size: FontSizeConstants.XX_SMALL,
              weight: FontWeight.w500,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

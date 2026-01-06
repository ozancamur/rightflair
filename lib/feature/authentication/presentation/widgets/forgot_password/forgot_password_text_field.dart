import 'package:flutter/material.dart';

import '../../../../../core/components/text_field.dart';
import '../../../../../core/constants/string.dart';

class ForgotPasswordTextField extends StatelessWidget {
  const ForgotPasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      controller: TextEditingController(),
      hintText: AppStrings.EMAIL,
      regExp: RegExp(''),
      errorText: "",
    );
  }
}

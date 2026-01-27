import 'package:flutter/material.dart';

import '../../../../core/components/button/elevated_button.dart';
import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonComponent(
      radius: 100,
      width: context.width * .8,
      color: context.colors.outline,
      onPressed: () {},
      child: TextComponent(
        color: context.colors.primaryContainer,
        text: AppStrings.FORGOT_PASSWORD_SEND_RESET_EMAIL,
        size: FontSizeConstants.LARGE,
        weight: FontWeight.w600,
      ),
    );
  }
}

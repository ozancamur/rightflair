import 'package:flutter/material.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../../core/components/elevated_button.dart';
import '../../../../core/components/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class RegisterButtonWidget extends StatelessWidget {
  final bool isLoading;
  final Function() onRegister;
  const RegisterButtonWidget({
    super.key,
    required this.onRegister,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonComponent(
      height: context.height * .07,
      radius: 100,
      color: context.colors.outline,
      onPressed: onRegister,
      child: isLoading
          ? LoadingComponent()
          : TextComponent(
              color: context.colors.primaryContainer,
              text: AppStrings.REGISTER_CREATE_ACCOUNT,
              size: FontSizeConstants.LARGE,
              weight: FontWeight.w600,
            ),
    );
  }
}

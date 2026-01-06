import 'package:flutter/material.dart';

import '../../../../../core/components/elevated_button.dart';
import '../../../../../core/components/text.dart';
import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';

class ChooseUsernameButtonWidget extends StatelessWidget {
  const ChooseUsernameButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonComponent(
      height: context.height * .07,
      radius: 100,
      color: AppDarkColors.INACTIVE,
      onPressed: () {},
      child: TextComponent(
        color: AppDarkColors.WHITE75,
        text: AppStrings.CONTINUE,
        size: FontSizeConstants.LARGE,
        weight: FontWeight.w600,
      ),
    );
  }
}
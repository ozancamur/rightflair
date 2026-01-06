import 'package:flutter/material.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';

class WelcomeOrWidget extends StatelessWidget {
  const WelcomeOrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .05,
      width: context.width,
      child: Row(
        spacing: context.width * 0.05,
        children: [
          Expanded(
            child: Divider(color: AppDarkColors.DARK_GREY, thickness: 1.5),
          ),
          TextComponent(
            text: AppStrings.OR,
            size: FontSizeConstants.SMALL,
            color: AppDarkColors.DARK_GREY,
            weight: FontWeight.w500,
          ),
          Expanded(
            child: Divider(color: AppDarkColors.DARK_GREY, thickness: 1.5),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/extensions/context.dart';

class ProfileTabItemWidget extends StatelessWidget {
  final String text;
  final bool isActive;
  const ProfileTabItemWidget({
    super.key,
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: context.height * 0.005,
      children: [
        TextComponent(
          text: text,
          size: FontSizeConstants.NORMAL,
          weight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? AppDarkColors.PRIMARY : AppDarkColors.WHITE60,
        ),
        if (isActive)
          Container(
            height: context.height * 0.003,
            width: context.width * 0.1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppDarkColors.BUTTON),
              borderRadius: BorderRadius.circular(context.width * 0.01),
            ),
          ),
      ],
    );
  }
}

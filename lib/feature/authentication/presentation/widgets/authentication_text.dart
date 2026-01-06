import 'package:flutter/material.dart';

import '../../../../core/components/text.dart';
import '../../../../core/constants/dark_color.dart';
import '../../../../core/constants/font_size.dart';
import '../../../../core/extensions/context.dart';

class AuthenticationTextWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthenticationTextWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .1,
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * .005,
        children: [
          TextComponent(
            text: title,
            size: FontSizeConstants.HUGE,
            weight: FontWeight.w600,
            color: AppDarkColors.PRIMARY,
          ),
          TextComponent(
            text: subtitle,
            size: FontSizeConstants.SMALL,
            weight: FontWeight.w500,
            color: AppDarkColors.WHITE75,
          ),
        ],
      ),
    );
  }
}

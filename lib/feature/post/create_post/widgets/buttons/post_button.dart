import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/components/button/gradient_button.dart';
import '../../../../../core/components/text/text.dart';
import '../../../../../core/constants/font/font_size.dart';
import '../../../../../core/constants/icons.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';

class CreatePostButtonWidget extends StatelessWidget {
  final VoidCallback onPost;
  const CreatePostButtonWidget({super.key, required this.onPost});

  @override
  Widget build(BuildContext context) {
    return GradientButtonComponent(
      height: context.height * 0.065,
      onPressed: onPost,
      radius: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: context.width * .02,
        children: [
          SvgPicture.asset(
            AppIcons.CHECK,
            colorFilter:  ColorFilter.mode(
              context.colors.primary,
              BlendMode.srcIn,
            ),
            width: context.width * .05,
          ),
          TextComponent(
            text: AppStrings.CREATE_POST_POST,
            size: FontSizeConstants.LARGE,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

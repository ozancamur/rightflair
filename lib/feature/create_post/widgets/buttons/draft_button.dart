import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/elevated_button.dart';
import 'package:rightflair/core/constants/font_size.dart';

import '../../../../core/components/text.dart';
import '../../../../core/constants/dark_color.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class CreateDraftButtonWidget extends StatelessWidget {
  final VoidCallback onDraft;
  const CreateDraftButtonWidget({super.key, required this.onDraft});

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonComponent(
      onPressed: onDraft,
      height: context.height * 0.065,
      borderWidth: 1,
      borderColor: AppDarkColors.WHITE16,
      color: Colors.transparent,
      radius: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: context.width * .02,
        children: [
          SvgPicture.asset(
            AppIcons.DRAFT,
            colorFilter:  ColorFilter.mode(
              AppDarkColors.PRIMARY,
              BlendMode.srcIn,
            ),
            width: context.width * .05,
          ),
          TextComponent(
            text: AppStrings.CREATE_POST_DRAFT,
            size: FontSizeConstants.LARGE,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

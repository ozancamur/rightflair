import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/button/elevated_button.dart';
import 'package:rightflair/core/components/button/gradient_button.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class PostUpdateBottomButtons extends StatelessWidget {
  final VoidCallback onDraft;
  final VoidCallback onPost;

  const PostUpdateBottomButtons({
    super.key,
    required this.onDraft,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButtonComponent(
              onPressed: onDraft,
              height: context.height * 0.065,
              borderWidth: 1,
              borderColor: context.colors.primaryFixedDim,
              color: Colors.transparent,
              radius: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: context.width * .02,
                children: [
                  SvgPicture.asset(
                    AppIcons.DRAFT,
                    colorFilter: ColorFilter.mode(
                      context.colors.primary,
                      BlendMode.srcIn,
                    ),
                    width: context.width * .05,
                  ),
                  TextComponent(
                    text: AppStrings.UPDATE_POST_DRAFT,
                    size: FontSizeConstants.LARGE,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: context.width * 0.04),
          Expanded(
            child: GradientButtonComponent(
              height: context.height * 0.065,
              onPressed: onPost,
              radius: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: context.width * .02,
                children: [
                  SvgPicture.asset(
                    AppIcons.CHECK,
                    colorFilter: ColorFilter.mode(
                      context.colors.primary,
                      BlendMode.srcIn,
                    ),
                    width: context.width * .05,
                  ),
                  TextComponent(
                    text: AppStrings.UPDATE_POST_POST,
                    size: FontSizeConstants.LARGE,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

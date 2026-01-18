import 'package:flutter/material.dart';
import 'package:rightflair/core/components/elevated_button.dart';
import 'package:rightflair/core/components/gradient_button.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../../../../../core/extensions/context.dart';
import 'suggested_account_image.dart';
import 'suggested_account_user.dart';

class SuggestedAccountItemWidget extends StatelessWidget {
  final String username;
  final String handle;
  final String profileImage;

  const SuggestedAccountItemWidget({
    super.key,
    required this.username,
    required this.handle,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        color: context.colors.onSecondary,
        borderRadius: BorderRadius.circular(context.width * 0.03),
      ),
      child: Column(
        spacing: context.height * .01,
        children: [_top(context), _buttons(context)],
      ),
    );
  }

  Row _top(BuildContext context) {
    return Row(
      children: [
        // Profile image
        SuggestedAccountImageWidget(image: profileImage),
        SizedBox(width: context.width * 0.03),

        // Username and handle
        SuggestedAccountUserWidget(username: username, handle: handle),

        // More button
      ],
    );
  }

  SizedBox _buttons(BuildContext context) {
    return SizedBox(
      height: context.height * .035,
      width: context.width,
      child: Row(
        spacing: context.height * .01,
        children: [
          Expanded(
            child: ElevatedButtonComponent(
              color: context.colors.primary,
              child: TextComponent(
                text: "Remove",
                color: context.colors.secondary,
                size: FontSizeConstants.SMALL,
                weight: FontWeight.w500,
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: GradientButtonComponent(
              child: TextComponent(
                text: "Follow",
                color: context.colors.secondary,
                size: FontSizeConstants.SMALL,
                weight: FontWeight.w500,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

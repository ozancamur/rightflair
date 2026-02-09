import 'package:flutter/material.dart';
import 'package:rightflair/core/components/button/elevated_button.dart';
import 'package:rightflair/core/components/button/gradient_button.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/notification_sender.dart';

import '../../../../core/extensions/context.dart';
import '../user_image.dart';
import 'suggested_account_user.dart';

class SuggestedAccountItemWidget extends StatelessWidget {
  final NotificationSenderModel user;

  const SuggestedAccountItemWidget({super.key, required this.user});

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
        UserImageWidget(id: user.id, url: user.profilePhotoUrl),
        SizedBox(width: context.width * 0.03),

        // Username and handle
        SuggestedAccountUserWidget(
          fullname: user.fullName,
          username: user.username,
        ),

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
                text: AppStrings.INBOX_REMOVE,
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
                text: AppStrings.INBOX_FOLLOW,
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

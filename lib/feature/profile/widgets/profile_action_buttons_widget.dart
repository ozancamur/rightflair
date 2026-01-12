import 'package:flutter/material.dart';
import 'package:rightflair/core/components/elevated_button.dart';
import 'package:rightflair/core/components/gradient_button.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileActionButtonsWidget extends StatelessWidget {
  final VoidCallback onFollowTap;
  final VoidCallback onMessageTap;
  const ProfileActionButtonsWidget({
    super.key,
    required this.onFollowTap,
    required this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * .075),
      child: Row(
        children: [
          Expanded(child: _followButton(context)),
          SizedBox(width: context.width * 0.05),
          Expanded(child: _messageButton(context)),
        ],
      ),
    );
  }

  Widget _followButton(BuildContext context) {
    return GradientButtonComponent(
      onPressed: onFollowTap,
      radius: 14,
      height: context.height * 0.0425,
      child: TextComponent(
        text: AppStrings.PROFILE_FOLLOW,
        size: FontSizeConstants.SMALL,
        weight: FontWeight.w600,
        color: AppDarkColors.PRIMARY,
      ),
    );
  }

  Widget _messageButton(BuildContext context) {
    return ElevatedButtonComponent(
      onPressed: onMessageTap,
      height: context.height * 0.0425,
      radius: 14,
      color: AppDarkColors.WHITE16,
      borderColor: AppDarkColors.WHITE32,
      borderWidth: .5,
      child: TextComponent(
        text: AppStrings.PROFILE_MESSAGE,
        size: FontSizeConstants.SMALL,
        weight: FontWeight.w600,
        color: AppDarkColors.PRIMARY,
      ),
    );
  }
}

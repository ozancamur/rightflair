import 'package:flutter/material.dart';
import 'package:rightflair/core/components/button/elevated_button.dart';
import 'package:rightflair/core/components/button/gradient_button.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileActionButtonsComponent extends StatelessWidget {
  final VoidCallback onFollowTap;
  final VoidCallback onMessageTap;
  final bool isFollowing;
  const ProfileActionButtonsComponent({
    super.key,
    required this.onFollowTap,
    required this.onMessageTap,
    this.isFollowing = false,
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
    return isFollowing
        ? ElevatedButtonComponent(
            onPressed: onFollowTap,
            height: context.height * 0.04,
            radius: 14,
            color: context.colors.tertiaryFixed,
            borderColor: context.colors.tertiaryFixedDim,
            borderWidth: .5,
            child: TextComponent(
              text: AppStrings.PROFILE_FOLLOWING,
              size: FontSizeConstants.NORMAL,
              weight: FontWeight.w600,
              color: context.colors.primary,
            ),
          )
        : GradientButtonComponent(
            onPressed: onFollowTap,
            radius: 14,
            height: context.height * 0.04,
            child: TextComponent(
              text: AppStrings.PROFILE_FOLLOW,
              size: FontSizeConstants.NORMAL,
              weight: FontWeight.w600,
              color: context.colors.primary,
            ),
          );
  }

  Widget _messageButton(BuildContext context) {
    return ElevatedButtonComponent(
      onPressed: onMessageTap,
      height: context.height * 0.04,
      radius: 14,
      color: context.colors.tertiaryFixed,
      borderColor: context.colors.tertiaryFixedDim,
      borderWidth: .5,
      child: TextComponent(
        text: AppStrings.PROFILE_MESSAGE,
        size: FontSizeConstants.NORMAL,
        weight: FontWeight.w600,
        color: context.colors.primary,
      ),
    );
  }
}

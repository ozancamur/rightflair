import 'package:flutter/material.dart';
import 'package:rightflair/core/components/elevated_button.dart';
import 'package:rightflair/core/components/gradient_button.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileActionButtonsComponent extends StatelessWidget {
  final VoidCallback onFollowTap;
  final VoidCallback onMessageTap;
  const ProfileActionButtonsComponent({
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

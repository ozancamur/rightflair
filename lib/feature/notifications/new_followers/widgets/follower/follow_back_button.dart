import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../../core/components/text/text.dart';
import '../../../../../core/constants/font/font_size.dart';
import '../../../../../core/extensions/context.dart';

class FollowBackButtonWidget extends StatelessWidget {
  final bool isFollowing;
  const FollowBackButtonWidget({super.key, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.04,
          vertical: context.height * 0.01,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isFollowing
                ? [context.colors.onPrimaryFixed, context.colors.onPrimaryFixed]
                : [context.colors.surface, context.colors.scrim],
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: TextComponent(
          text: isFollowing
              ? AppStrings.INBOX_REMOVE
              : AppStrings.INBOX_FOLLOW_BACK,
          size: FontSizeConstants.X_SMALL,
          weight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

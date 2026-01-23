import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileTagComponent extends StatelessWidget {
  final String text;
  const ProfileTagComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.055,
        vertical: context.height * 0.006,
      ),
      decoration: BoxDecoration(
        color: context.colors.onSecondary,
        borderRadius: BorderRadius.circular(context.width * 0.05),
      ),
      child: TextComponent(
        text: AppStrings.STYLE_TAG(text),
        size: FontSizeConstants.X_SMALL,
        weight: FontWeight.w500,
        color: context.colors.primary,
      ),
    );
  }
}

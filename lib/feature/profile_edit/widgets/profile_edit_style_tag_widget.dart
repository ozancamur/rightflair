import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileEditStyleTagWidget extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;

  const ProfileEditStyleTagWidget({
    super.key,
    required this.text,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemove,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.04,
          vertical: context.height * 0.008,
        ),
        decoration: BoxDecoration(
          color: context.colors.onSecondary,
          borderRadius: BorderRadius.circular(context.width * 0.05),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: context.width * 0.02,
          children: [
            TextComponent(
              text: text,
              size: FontSizeConstants.SMALL,
              weight: FontWeight.w500,
              color: context.colors.primary,
              tr: false,
            ),
            SvgPicture.asset(
              AppIcons.CLOSE,
              height: context.height * 0.01,
              color: context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

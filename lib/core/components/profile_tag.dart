import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../constants/dark_color.dart';

class ProfileTagComponent extends StatelessWidget {
  final String text;
  const ProfileTagComponent({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.007,
      ),
      decoration: BoxDecoration(
        color: AppDarkColors.WHITE16,
        borderRadius: BorderRadius.circular(context.width * 0.05),
      ),
      child: TextComponent(
        text: text,
        size: FontSizeConstants.XXX_SMALL,
        weight: FontWeight.w500,
        color: AppDarkColors.PRIMARY,
      ),
    );
  }
}

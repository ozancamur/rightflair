import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font_size.dart';

import '../../../../../core/constants/dark_color.dart';

class ProfileStatsWidget extends StatelessWidget {
  final int count;
  final String label;
  const ProfileStatsWidget({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextComponent(
          text: count.toString(),
          size: FontSizeConstants.XXXX_LARGE,
          weight: FontWeight.w700,
          color: AppDarkColors.PRIMARY,
          tr: false,
        ),
        TextComponent(
          text: label,
          size: FontSizeConstants.XX_SMALL,
          weight: FontWeight.w500,
          color: AppDarkColors.WHITE75,
        ),
      ],
    );
  }
}

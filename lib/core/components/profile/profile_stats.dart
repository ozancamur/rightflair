import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../extensions/context.dart';

class ProfileStatsComponent extends StatelessWidget {
  final int count;
  final String label;
  final VoidCallback? onTap;
  const ProfileStatsComponent({
    super.key,
    required this.count,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.width * 0.02),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.02,
          vertical: context.height * 0.005,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextComponent(
              text: count.toString(),
              size: FontSizeConstants.XXXX_LARGE,
              weight: FontWeight.w700,
              color: context.colors.primary,
              tr: false,
            ),
            TextComponent(
              text: label,
              size: FontSizeConstants.SMALL,
              weight: FontWeight.w500,
              color: context.colors.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}

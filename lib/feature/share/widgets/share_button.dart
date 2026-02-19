import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/extensions/context.dart';

class ShareButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String label;
  final Color color;
  const ShareButtonWidget({
    super.key,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.width * 0.03),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.height * 0.015,
          horizontal: context.width * 0.05,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: context.width * 0.06,
              height: context.width * 0.06,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(width: context.width * 0.04),
            Expanded(
              child: TextComponent(
                text: label,
                size: FontSizeConstants.NORMAL,
                weight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

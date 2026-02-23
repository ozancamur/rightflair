import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/extensions/context.dart';

class FindFriendsActionTile extends StatelessWidget {
  final Color iconBackgroundColor;
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const FindFriendsActionTile({
    super.key,
    required this.iconBackgroundColor,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.width * 0.02),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.04,
          vertical: context.height * 0.015,
        ),
        child: Row(
          children: [
            Container(
              width: context.width * 0.12,
              height: context.width * 0.12,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  height: context.width * 0.06,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComponent(
                    text: title.tr(),
                    tr: false,
                    size: FontSizeConstants.NORMAL,
                    weight: FontWeight.w600,
                    color: context.colors.primary,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.height * 0.003),
                  TextComponent(
                    text: subtitle.tr(),
                    tr: false,
                    size: FontSizeConstants.SMALL,
                    weight: FontWeight.w400,
                    color: context.colors.primaryContainer,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.colors.primaryContainer,
              size: context.width * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}

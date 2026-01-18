import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import '../../../../core/components/text.dart';
import '../../../../core/extensions/context.dart';

class SettingsListItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsListItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: context.height * 0.08,
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
        child: Center(
          child: Row(
            spacing: context.width * 0.04,
            children: [
              SvgPicture.asset(
                icon,
                height: context.height * .025,
                color: context.colors.primary,
              ),
              _buildContent(context),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          TextComponent(
            text: title,
            size: FontSizeConstants.LARGE,
            color: context.colors.primary,
            weight: FontWeight.w500,
          ),
          if (subtitle != null) ...[
            SizedBox(height: context.height * 0.002),
            TextComponent(
              text: subtitle!,
              size: FontSizeConstants.X_SMALL,
              color: context.colors.primaryFixed,
              weight: FontWeight.w500,
            ),
          ],
        ],
      ),
    );
  }
}

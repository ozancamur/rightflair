import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/extensions/context.dart';

class CreatePostOptionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconPath;
  final Widget trailing;
  final VoidCallback? onTap;

  const CreatePostOptionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconPath,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.height * 0.02),
        padding: EdgeInsets.all(context.width * 0.04),
        decoration: BoxDecoration(
          color: context.colors.shadow,
          borderRadius: BorderRadius.circular(context.width * 0.04),
          border: Border.all(color: context.colors.primaryFixedDim),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: context.width * 0.06,
              colorFilter:  ColorFilter.mode(
                context.colors.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: context.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComponent(
                    text: title,
                    size: const [16],
                    weight: FontWeight.w600,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: context.height * 0.005),
                    TextComponent(
                      text: subtitle!,
                      size: const [12],
                      color: context.colors.onPrimary,
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

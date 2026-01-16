import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';

import '../extensions/context.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final double? leadingWidth;
  final String? title;
  final List<Widget>? actions;
  const AppBarComponent({
    super.key,
    this.leading,
    this.leadingWidth,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppDarkColors.SECONDARY,
      foregroundColor: AppDarkColors.PRIMARY,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: context.width * .035),
        child: leading,
      ),
      leadingWidth: leadingWidth,
      actions: actions,
      title: TextComponent(
        text: title ?? "",
        size: FontSizeConstants.X_LARGE,
        color: AppDarkColors.PRIMARY,
        weight: FontWeight.w600,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

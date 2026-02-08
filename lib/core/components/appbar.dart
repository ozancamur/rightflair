import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

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
      backgroundColor: context.colors.secondary,
      foregroundColor: context.colors.primary,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: context.width * .045),
        child: leading,
      ),
      leadingWidth: leadingWidth,
      actionsPadding: EdgeInsets.symmetric(vertical: context.height * .01),
      actions: actions,
      title: TextComponent(
        text: title ?? "",
        size: FontSizeConstants.X_LARGE,
        color: context.colors.primary,
        weight: FontWeight.w600,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

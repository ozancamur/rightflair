import 'package:flutter/material.dart';

import '../extensions/context.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final double? leadingWidth;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  const AppBarComponent({
    super.key,
    this.leading,
    this.leadingWidth,
    this.title,
    this.actions,
    this.bottom,
    this.centerTitle,
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
      title: title,
      bottom: bottom,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

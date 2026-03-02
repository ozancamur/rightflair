import 'package:flutter/material.dart';

import '../extensions/context.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  const AppBarComponent({
    super.key,
    this.leading,
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
      automaticallyImplyLeading: false,
      leadingWidth: context.height * .06,
      leading: Padding(
        padding: EdgeInsets.only(left: context.height * .015),
        child: leading,
      ),
      titleSpacing: 0,
      title: title,
      centerTitle: centerTitle,
      actionsPadding: EdgeInsets.only(right: context.height * .015),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

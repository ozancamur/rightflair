import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  const AppBarComponent({super.key, this.leading, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppDarkColors.SECONDARY,
      foregroundColor: AppDarkColors.PRIMARY,
      elevation: 0,
      leading: leading,
      title: TextComponent(
        text: title ?? "",
        size: FontSizeConstants.X_LARGE,
        color: Colors.white,
        weight: FontWeight.w600,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

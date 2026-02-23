import 'package:flutter/material.dart';
import 'package:rightflair/core/components/button/back_button.dart';

import '../../../core/components/appbar.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';

class FindFriendsAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const FindFriendsAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(),
      centerTitle: true,
      title: TextComponent(
        text: AppStrings.FIND_FRIENDS_TITLE,
        size: FontSizeConstants.X_LARGE,
        weight: FontWeight.w700,
        color: context.colors.primary,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

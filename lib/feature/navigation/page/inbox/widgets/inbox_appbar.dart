import 'package:flutter/material.dart';

import '../../../../../core/components/appbar.dart';
import '../../../../../core/components/button/icon_button.dart';
import '../../../../../core/constants/icons.dart';

class InboxAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const InboxAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      actions: [
        IconButtonComponent(icon: AppIcons.SEARCH_FILLED, onTap: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

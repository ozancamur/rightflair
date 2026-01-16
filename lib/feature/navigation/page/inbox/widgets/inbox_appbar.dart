import 'package:flutter/material.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../core/components/appbar.dart';
import '../../../../../core/components/icon_button.dart';
import '../../../../../core/constants/icons.dart';

class InboxAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const InboxAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          child: IconButtonComponent(
            size: context.height * 0.045,
            icon: AppIcons.SEARCH_FILLED,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';

import '../../../../../core/components/appbar.dart';
import '../../../../../core/components/back_button.dart';
import '../../../../../core/components/icon_button.dart';
import '../../../../../core/constants/icons.dart';
import '../../../../../core/extensions/context.dart';

class ProfileAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(),
      actions: [
        IconButtonComponent(onTap: () {}, icon: AppIcons.SHARE),
        SizedBox(width: context.width * 0.03),
        IconButtonComponent(onTap: () {}, icon: AppIcons.SETTINGS),
        SizedBox(width: context.width * .04),
      ],
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
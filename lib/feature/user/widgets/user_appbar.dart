import 'package:flutter/material.dart';
import 'package:rightflair/core/components/button/back_button.dart';
import 'package:rightflair/feature/share/dialog/dialog_share.dart';

import '../../../../../../../core/components/appbar.dart';
import '../../../core/components/button/icon_button.dart';
import '../../../../../../../core/constants/icons.dart';
import '../../../../../../../core/extensions/context.dart';

class UserAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String userId;
  final String fullname;
  final bool isNotificationEnabled;
  final bool isFollowing;
  const UserAppbarWidget({
    super.key,
    required this.userId,
    required this.fullname,
    required this.isFollowing,
    required this.isNotificationEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(),
      actions: [
        IconButtonComponent(
          onTap: () => dialogShare(context, userId: userId),
          icon: AppIcons.SHARE,
        ),
        SizedBox(width: context.width * 0.01),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/main/profile/cubit/profile_cubit.dart';
import 'package:rightflair/feature/share/dialog/dialog_share.dart';

import '../../../../../../core/components/appbar.dart';
import '../../../../core/components/button/icon_button.dart';
import '../../../../../../core/constants/icons.dart';
import '../../../../../../core/extensions/context.dart';
import '../../../../core/components/button/settings_button.dart';

class ProfileAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? userId;
  const ProfileAppbarWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      leading: IconButtonComponent(
        onTap: () => context.push(RouteConstants.FIND_FRIENDS),
        icon: AppIcons.ADD_FRIEND,
      ),
      actions: [
        IconButtonComponent(
          onTap: () => (userId == null || userId == "")
              ? null
              : dialogShare(context, userId: userId ?? "", showReport: false),
          icon: AppIcons.SHARE,
        ),
        SizedBox(width: context.width * 0.02),
        SettingsButtonComponent(
          onSettings: () async {
            final rsult = await context.push(RouteConstants.SETTINGS);
            if (rsult != null && context.mounted) {
              context.read<ProfileCubit>().refresh();
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/button/back_button.dart';

import '../../../core/components/text/appbar_title.dart';
import '../../../core/constants/string.dart';

class SettingsAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingsAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(onBack: () => context.pop('refresh')),
      title: AppbarTitleComponent(title: AppStrings.SETTINGS_TITLE),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

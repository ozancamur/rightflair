import 'package:flutter/material.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/back_button.dart';

import '../../../core/constants/string.dart';

class SettingsAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingsAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(),
      title: AppStrings.SETTINGS_TITLE,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

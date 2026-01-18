import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/settings/cubit/settings_cubit.dart';

import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import 'settings_button_widget.dart';

class SettingsButtonsWidget extends StatelessWidget {
  const SettingsButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [_logout(context), _deactive(context)]);
  }

  SettingsButtonWidget _logout(BuildContext context) {
    return SettingsButtonWidget(
      icon: Icons.logout,
      title: AppStrings.SETTINGS_LOG_OUT,
      textColor: context.colors.primary,
      onTap: () => context.read<SettingsCubit>().logOut(),
    );
  }

  SettingsButtonWidget _deactive(BuildContext context) {
    return SettingsButtonWidget(
      title: AppStrings.SETTINGS_DEACTIVE_ACCOUNT,
      textColor: context.colors.tertiary,
      onTap: () => context.read<SettingsCubit>().deactivateAccount(),
    );
  }
}

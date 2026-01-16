import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/icons.dart';

import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../settings_divider.dart';
import '../settings_list_item_widget.dart';
import '../settings_section_header_widget.dart';

class SettingsAccountWidget extends StatelessWidget {
  final String username;
  final String email;
  const SettingsAccountWidget({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeaderWidget(title: AppStrings.SETTINGS_ACCOUNT),
        Container(
          margin: EdgeInsets.symmetric(horizontal: context.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: .5, color: AppDarkColors.WHITE50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _username(context),
              const SettingsDividerWidget(),
              _email(context),
              const SettingsDividerWidget(),
              _changePassword(context),
            ],
          ),
        ),
      ],
    );
  }

  SettingsListItemWidget _username(BuildContext context) {
    return SettingsListItemWidget(
      icon: AppIcons.USERNAME,
      title: AppStrings.SETTINGS_USERNAME,
      subtitle: username,
      trailing: Icon(
        Icons.chevron_right,
        color: AppDarkColors.PRIMARY,
        size: context.width * 0.06,
      ),
      onTap: () {},
    );
  }

  SettingsListItemWidget _email(BuildContext context) {
    return SettingsListItemWidget(
      icon: AppIcons.EMAIL,
      title: AppStrings.SETTINGS_EMAIL,
      subtitle: email,
      trailing: Icon(
        Icons.chevron_right,
        color: AppDarkColors.PRIMARY,
        size: context.width * 0.06,
      ),
      onTap: () {},
    );
  }

  SettingsListItemWidget _changePassword(BuildContext context) {
    return SettingsListItemWidget(
      icon: AppIcons.CHANGE_PASSWORD,
      title: AppStrings.SETTINGS_CHANGE_PASSWORD,
      trailing: Icon(
        Icons.chevron_right,
        color: AppDarkColors.PRIMARY,
        size: context.width * 0.06,
      ),
      onTap: () {},
    );
  }
}

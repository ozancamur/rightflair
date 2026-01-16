import 'package:flutter/material.dart';

import '../../../../core/constants/dark_color.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../settings_list_item_widget.dart';
import '../settings_section_header_widget.dart';

class SettingsSupportWidget extends StatelessWidget {
  const SettingsSupportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeaderWidget(title: AppStrings.SETTINGS_SUPPORT),
        Container(
          margin: EdgeInsets.symmetric(horizontal: context.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: .5, color: AppDarkColors.WHITE50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SettingsListItemWidget(
            icon: AppIcons.CONTACT,
            title: AppStrings.SETTINGS_CONTACT_SUPPORT,
            trailing: Icon(
              Icons.chevron_right,
              color: AppDarkColors.PRIMARY,
              size: context.width * 0.06,
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

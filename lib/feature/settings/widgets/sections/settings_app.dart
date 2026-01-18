import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/feature/settings/widgets/settings_divider.dart';

import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../cubit/settings_cubit.dart';
import '../settings_list_item_widget.dart';
import '../settings_section_header_widget.dart';
import '../settings_toggle_item_widget.dart';

class SettingsAppWidget extends StatelessWidget {
  final bool darkmode;
  final String language;
  const SettingsAppWidget({
    super.key,
    required this.darkmode,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeaderWidget(title: AppStrings.SETTINGS_APP),
        Container(
          margin: EdgeInsets.symmetric(horizontal: context.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: .5, color: context.colors.primaryFixed),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _darkMode(context, cubit),
              const SettingsDividerWidget(),
              _language(context),
            ],
          ),
        ),
      ],
    );
  }

  Container _darkMode(BuildContext context, SettingsCubit cubit) {
    return Container(
      height: context.height * .08,
      padding: EdgeInsets.only(left: context.width * 0.055),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.DARK_MODE,
            height: context.height * .025,
            color: context.colors.primary,
          ),
          Expanded(
            child: SettingsToggleItemWidget(
              title: AppStrings.SETTINGS_DARK_MODE,
              value: darkmode,
              onChanged: cubit.toggleDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  SettingsListItemWidget _language(BuildContext context) {
    return SettingsListItemWidget(
      icon: AppIcons.LANGUAGE,
      title: AppStrings.SETTINGS_LANGUAGE,
      subtitle: language,
      trailing: Icon(
        Icons.chevron_right,
        color: context.colors.primary,
        size: context.width * 0.06,
      ),
      onTap: () {},
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../cubit/settings_cubit.dart';
import '../settings_list_item_widget.dart';
import '../settings_section_header_widget.dart';

class SettingsAppWidget extends StatelessWidget {
  final ThemeMode themeMode;
  const SettingsAppWidget({super.key, required this.themeMode});

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
              _themeMode(context, cubit),
              /*const SettingsDividerWidget(),
              _language(context),*/
            ],
          ),
        ),
      ],
    );
  }

  Widget _themeMode(BuildContext context, SettingsCubit cubit) {
    String currentTheme;
    switch (themeMode) {
      case ThemeMode.system:
        currentTheme = AppStrings.SETTINGS_THEME_MODE_AUTO.tr();
        break;
      case ThemeMode.light:
        currentTheme = AppStrings.SETTINGS_THEME_MODE_LIGHT.tr();
        break;
      case ThemeMode.dark:
        currentTheme = AppStrings.SETTINGS_THEME_MODE_DARK.tr();
        break;
    }

    return SettingsListItemWidget(
      icon: AppIcons.DARK_MODE,
      title: AppStrings.SETTINGS_THEME_MODE,
      subtitle: currentTheme,
      trailing: Icon(
        Icons.chevron_right,
        color: context.colors.primary,
        size: context.width * 0.06,
      ),
      onTap: () => _showThemeDialog(context, cubit),
    );
  }

  void _showThemeDialog(BuildContext context, SettingsCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _themeOption(
                context,
                cubit,
                AppStrings.SETTINGS_THEME_MODE_AUTO.tr(),
                ThemeMode.system,
                themeMode == ThemeMode.system,
              ),
              _themeOption(
                context,
                cubit,
                AppStrings.SETTINGS_THEME_MODE_LIGHT.tr(),
                ThemeMode.light,
                themeMode == ThemeMode.light,
              ),
              _themeOption(
                context,
                cubit,
                AppStrings.SETTINGS_THEME_MODE_DARK.tr(),
                ThemeMode.dark,
                themeMode == ThemeMode.dark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _themeOption(
    BuildContext context,
    SettingsCubit cubit,
    String title,
    ThemeMode mode,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        cubit.setThemeMode(context, mode);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.06,
          vertical: context.height * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: context.colors.primary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: context.colors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  /*
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
  }*/
}

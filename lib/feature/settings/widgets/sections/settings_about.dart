import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/settings/widgets/settings_divider.dart';

import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../cubit/settings_cubit.dart';
import '../settings_list_item_widget.dart';
import '../settings_section_header_widget.dart';

class SettingsAboutWidget extends StatelessWidget {
  const SettingsAboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeaderWidget(title: AppStrings.SETTINGS_ABOUT),
        Container(
          margin: EdgeInsets.symmetric(horizontal: context.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: .5, color: context.colors.primaryFixed),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SettingsListItemWidget(
                icon: AppIcons.TERMS,
                title: AppStrings.SETTINGS_TERMS_OF_SERVICE,
                trailing: Icon(
                  Icons.chevron_right,
                  color: context.colors.primary,
                  size: context.width * 0.06,
                ),
                onTap: () => context.read<SettingsCubit>().openTermsOfUse(),
              ),
              const SettingsDividerWidget(),
              SettingsListItemWidget(
                icon: AppIcons.PRIVACY,
                title: AppStrings.SETTINGS_PRIVACY_POLICY,
                trailing: Icon(
                  Icons.chevron_right,
                  color: context.colors.primary,
                  size: context.width * 0.06,
                ),
                onTap: () => context.read<SettingsCubit>().openPrivacyPolicy(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

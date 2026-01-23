import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/settings/widgets/settings_divider.dart';

import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../cubit/settings_cubit.dart';
import '../../model/notifications.dart';
import '../settings_section_header_widget.dart';
import '../settings_toggle_item_widget.dart';

class SettingsNotificationsWidget extends StatelessWidget {
  final NotificationsModel? notifications;
  const SettingsNotificationsWidget({super.key, this.notifications});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeaderWidget(title: AppStrings.SETTINGS_NOTIFICATIONS),
        Container(
          margin: EdgeInsets.symmetric(horizontal: context.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: .5, color: context.colors.primaryFixed),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _likes(cubit),
              const SettingsDividerWidget(),
              _saves(cubit),
              const SettingsDividerWidget(),
              _milestones(cubit),
              const SettingsDividerWidget(),
              _trending(cubit),
              const SettingsDividerWidget(),
              _follow(cubit),
            ],
          ),
        ),
      ],
    );
  }

  SettingsToggleItemWidget _likes(SettingsCubit cubit) {
    return SettingsToggleItemWidget(
      title: AppStrings.SETTINGS_LIKES,
      value: notifications?.enableLikes ?? false,
      onChanged: cubit.toggleLikes,
    );
  }

  SettingsToggleItemWidget _saves(SettingsCubit cubit) {
    return SettingsToggleItemWidget(
      title: AppStrings.SETTINGS_SAVES,
      value: notifications?.enableSaves ?? false,
      onChanged: cubit.toggleSaves,
    );
  }

  SettingsToggleItemWidget _milestones(SettingsCubit cubit) {
    return SettingsToggleItemWidget(
      title: AppStrings.SETTINGS_MILESTONES,
      value: notifications?.enableMilestones ?? false,
      onChanged: cubit.toggleMilestones,
    );
  }

  SettingsToggleItemWidget _trending(SettingsCubit cubit) {
    return SettingsToggleItemWidget(
      title: AppStrings.SETTINGS_TRENDING,
      value: notifications?.enableTrending ?? false,
      onChanged: cubit.toggleTrending,
    );
  }

  SettingsToggleItemWidget _follow(SettingsCubit cubit) {
    return SettingsToggleItemWidget(
      title: AppStrings.SETTINGS_FOLLOW,
      value: notifications?.enableFollow ?? false,
      onChanged: cubit.toggleFollow,
    );
  }
}

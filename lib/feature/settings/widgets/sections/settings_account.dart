import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/settings/cubit/settings_cubit.dart';

import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../settings_divider.dart';
import '../settings_list_item_widget.dart';
import '../settings_section_header_widget.dart';

class SettingsAccountWidget extends StatelessWidget {
  final String? username;
  final String? email;
  final bool? emailVerified;
  const SettingsAccountWidget({
    super.key,
    this.username,
    this.email,
    this.emailVerified,
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
            border: Border.all(width: .5, color: context.colors.primaryFixed),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _username(context),
              const SettingsDividerWidget(),
              _email(context),
              /*
              const SettingsDividerWidget(),
              _changePassword(context),
              */
            ],
          ),
        ),
      ],
    );
  }

  SettingsListItemWidget _username(BuildContext context) {
    final String _username = username ?? "rightflair_user";
    return SettingsListItemWidget(
      icon: AppIcons.USERNAME,
      title: AppStrings.SETTINGS_USERNAME,
      subtitle: "@$_username",
      trailing: SvgPicture.asset(
        AppIcons.ARROW_RIGHT,
        color: context.colors.primary,
        height: context.width * 0.03,
      ),
      onTap: () async {
        final result = await context.push(
          RouteConstants.CHOOSE_USERNAME,
          extra: {'username': _username, 'canPop': true},
        );
        if (result != null && context.mounted) {
          context.read<SettingsCubit>().updateUsername(result as String);
        }
      },
    );
  }

  SettingsListItemWidget _email(BuildContext context) {
    return SettingsListItemWidget(
      icon: AppIcons.EMAIL,
      title: AppStrings.SETTINGS_EMAIL,
      subtitle: email ?? AppStrings.DEFAULT_FALLBACK_EMAIL.tr(),
      trailing: emailVerified == true
          ? Icon(
              Icons.check_circle,
              color: context.colors.inverseSurface,
              size: context.width * 0.06,
            )
          : Icon(
              Icons.error,
              color: context.colors.error,
              size: context.width * 0.06,
            ),
    );
  }

  /*
  SettingsListItemWidget _changePassword(BuildContext context) {
    return SettingsListItemWidget(
      icon: AppIcons.CHANGE_PASSWORD,
      title: AppStrings.SETTINGS_CHANGE_PASSWORD,
      trailing: Icon(
        Icons.chevron_right,
        color: context.colors.primary,
        size: context.width * 0.06,
      ),
      onTap: () {},
    );
  }*/
}

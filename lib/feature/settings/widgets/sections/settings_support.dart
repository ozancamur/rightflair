import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../settings_divider.dart';
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
            border: Border.all(width: .5, color: context.colors.primaryFixed),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _contact(context),
              const SettingsDividerWidget(),
              _share(context),
            ],
          ),
        ),
      ],
    );
  }

  SettingsListItemWidget _contact(BuildContext context) {
    return SettingsListItemWidget(
      icon: AppIcons.CONTACT,
      title: AppStrings.SETTINGS_CONTACT_SUPPORT,
      trailing: Icon(
        Icons.chevron_right,
        color: context.colors.primary,
        size: context.width * 0.06,
      ),
      onTap: () async {
        final uri = Uri.parse(AppConstants.SUPPORT);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          debugPrint('Could not launch $uri');
        }
      },
    );
  }

  SettingsListItemWidget _share(BuildContext context) {
    return SettingsListItemWidget(
      icon: AppIcons.SHARE,
      title: AppStrings.SETTINGS_SHARE_US,
      trailing: Icon(
        Icons.chevron_right,
        color: context.colors.primary,
        size: context.width * 0.06,
      ),
      onTap: () async {
        final message =
            '${AppConstants.APP_NAME}\n\n'
            'App Store: ${AppConstants.APPLE}\n'
            'Play Store: ${AppConstants.GOOGLE}';
        await SharePlus.instance.share(ShareParams(text: message));
      },
    );
  }
}

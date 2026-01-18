import 'package:flutter/material.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/back_button.dart';
import 'package:rightflair/core/extensions/context.dart';
import '../../../../../core/base/base_scaffold.dart';
import '../../../../../core/components/settings_button.dart';
import '../../../../../core/constants/string.dart';
import '../widgets/system_notifications_list.dart';

class SystemNotificationsPage extends StatelessWidget {
  const SystemNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBarComponent(
        leading: BackButtonComponent(),
        title: AppStrings.INBOX_SYSTEM_NOTIFICATIONS_TITLE,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.width * .04),
            child: SettingsButtonComponent(),
          ),
        ],
      ),
      body: const SystemNotificationsListWidget(),
    );
  }
}

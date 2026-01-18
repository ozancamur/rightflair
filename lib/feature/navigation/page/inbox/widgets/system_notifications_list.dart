import 'package:flutter/material.dart';

import '../../../../../core/extensions/context.dart';
import 'system_notification_item/system_notification_item.dart';

class SystemNotificationsListWidget extends StatelessWidget {
  const SystemNotificationsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.02,
      ),
      children: const [
        SystemNotificationItem(
          title: 'Account Updates',
          message: 'was removed before view',
          description:
              'The ad you have reported has been removed by the advertiser. Thank you for your report.',
          timeAgo: '4h',
        ),
      ],
    );
  }
}

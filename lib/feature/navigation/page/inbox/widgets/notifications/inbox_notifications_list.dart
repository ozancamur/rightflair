import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/feature/navigation/page/inbox/widgets/notifications/inbox_notification_item.dart';

import '../../../../../../core/extensions/context.dart';
import '../../model/notification_model.dart';

class InboxNotificationsList extends StatelessWidget {
  final List<NotificationModel> notifications;
  const InboxNotificationsList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      itemCount: notifications.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) return _zero(context);
        if (index == notifications.length + 1) return _keep(context);
        return InboxNotificationItem(notification: notifications[index - 1]);
      },
    );
  }

  Padding _zero(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.height * 0.02,
        bottom: context.height * 0.02,
      ),
      child: TextComponent(
        text: AppStrings.INBOX_TODAYS_ACTIVITY,
        size: FontSizeConstants.LARGE,
        weight: FontWeight.w600,
        align: TextAlign.start,
        color: context.colors.primary,
      ),
    );
  }

  Container _keep(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.height * 0.02),
      padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.onSecondary,
        border: Border.all(color: context.colors.onTertiary.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: TextComponent(
          text: AppStrings.INBOX_KEEP_POSTING,
          color: context.colors.primary,
          size: FontSizeConstants.SMALL,
        ),
      ),
    );
  }
}

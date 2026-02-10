import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/helpers/date.dart';

import '../../../main/inbox/model/notification.dart';
import 'system_notification_icon.dart';

class SystemNotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const SystemNotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.height * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.width * .02,
      ),
      decoration: BoxDecoration(
        color: context.colors.onSecondary,
        border: Border.all(color: context.colors.onSecondary),
        borderRadius: BorderRadius.circular(context.width * 0.04),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: context.width * 0.03,
        children: [
          const SystemNotificationIconWidget(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComponent(
                  text: notification.title ?? "",
                  size: FontSizeConstants.SMALL,
                  weight: FontWeight.w600,
                  tr: false,
                  color: context.colors.primary,
                  maxLine: 2,
                ),
                TextComponent(
                  text: notification.content ?? "",
                  size: FontSizeConstants.X_SMALL,
                  color: context.colors.tertiary,
                  tr: false,
                  height: 1.25,
                ),
              ],
            ),
          ),
          TextComponent(
            text: '• ${DateHelper.timeAgo(notification.createdAt)}',
            size: FontSizeConstants.XX_SMALL,
            color: context.colors.tertiary,
            align: TextAlign.center,
            tr: false,
          ),
        ],
      ),
    );
  }
}

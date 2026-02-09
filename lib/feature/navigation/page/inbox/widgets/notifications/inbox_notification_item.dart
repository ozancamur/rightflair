import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/helpers/date.dart';

import '../../../../../../core/extensions/context.dart';
import '../../model/notification.dart';
import '../../../../../../core/constants/enums/notification_type.dart';
import 'notification_item.dart';

class InboxNotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const InboxNotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (notification.type == NotificationType.SYSTEM_UPDATE) {
          context.push(RouteConstants.SYSTEM_NOTIFICATIONS);
        } else if (notification.type == NotificationType.NEW_FOLLOWER) {
          context.push(RouteConstants.NEW_FOLLOWERS);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.height * 0.006),
        padding: EdgeInsets.symmetric(
          horizontal: context.width * .04,
          vertical: context.width * 0.02,
        ),
        decoration: BoxDecoration(
          color: context.colors.onBackground,
          borderRadius: BorderRadius.circular(context.width * 0.04),
        ),
        child: Row(
          spacing: context.width * 0.04,
          children: [
            NotificationItemWidget(type: notification.type),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComponent(
                    text: notification.title ?? '',
                    size: FontSizeConstants.SMALL,
                    weight: FontWeight.w500,
                    maxLine: 2,
                    tr: false,
                    color: context.colors.primary,
                  ),
                  if (notification.content != null) ...[
                    SizedBox(height: context.height * 0.005),
                    TextComponent(
                      text: notification.content ?? '',
                      size: FontSizeConstants.XX_SMALL,
                      color: context.colors.primary,
                      overflow: TextOverflow.ellipsis,
                      maxLine: 1,
                      tr: false,
                    ),
                  ],
                ],
              ),
            ),
            if (notification.createdAt != null) ...[
              SizedBox(width: context.width * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.02,
                  vertical: context.width * 0.01,
                ),
                decoration: BoxDecoration(
                  color: context.colors.onSecondary,
                  borderRadius: BorderRadius.circular(context.width * 0.02),
                ),
                child: TextComponent(
                  text: DateHelper.timeAgo(notification.createdAt),
                  size: FontSizeConstants.XX_SMALL,
                  color: context.colors.primary,
                  tr: false,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/notification_model.dart';

import '../../../../../../core/extensions/context.dart';
import '../../model/notification_type.dart';
import 'notification_item.dart';

class InboxNotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const InboxNotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (notification.type == NotificationType.system) {
          context.push(RouteConstants.SYSTEM_NOTIFICATIONS);
        } else if (notification.type == NotificationType.newFollower) {
          context.push(RouteConstants.NEW_FOLLOWERS);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.height * 0.01),
        padding: EdgeInsets.all(context.width * 0.04),
        decoration: BoxDecoration(
          color: context.colors.onBackground,
          borderRadius: BorderRadius.circular(context.width * 0.04),
          border: Border.all(color: context.colors.onTertiary.withOpacity(0.5)),
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
                    text: notification.title,
                    size: FontSizeConstants.SMALL,
                    weight: FontWeight.w500,
                    maxLine: 2,
                    tr: false,
                    color: context.colors.primary,
                  ),
                  if (notification.subtitle != null) ...[
                    SizedBox(height: context.height * 0.005),
                    TextComponent(
                      text: notification.subtitle!,
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
            if (notification.timeAgo.isNotEmpty) ...[
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
                  text: notification.timeAgo,
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

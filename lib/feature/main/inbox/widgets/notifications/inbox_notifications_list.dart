import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/enums/notification_type.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/feature/main/inbox/widgets/notifications/inbox_notification_item.dart';

import '../../../../../core/extensions/context.dart';
import '../../model/notification.dart';
import '../inbox_notification_button.dart';
import '../inbox_notification_keep.dart';

class InboxNotificationsList extends StatelessWidget {
  final List<NotificationModel> notifications;
  const InboxNotificationsList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height,
      width: context.width,
      child: Stack(
        children: [
          Positioned.fill(
            child: ListView.builder(
              padding: EdgeInsets.only(
                right: context.width * 0.04,
                left: context.width * 0.04,
                bottom: context.height * .2,
              ),
              itemCount: notifications.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _zero(context);
                return InboxNotificationItem(
                  notification: notifications[index - 1],
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: context.height * .325,
              width: context.width,
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
              decoration: BoxDecoration(color: context.colors.secondary),
              child: Column(
                children: [
                  const InboxNotificationKeep(),
                  InboxNotificationButtonWidget(
                    onTap: () => context.push(RouteConstants.NEW_FOLLOWERS),
                    type: NotificationType.NEW_FOLLOWER,
                    title: AppStrings.INBOX_NEW_FOLLOWERS_TITLE,
                    content: "",
                  ),
                  InboxNotificationButtonWidget(
                    onTap: () {},
                    type: NotificationType.SYSTEM_UPDATE,
                    title: AppStrings.INBOX_SYSTEM_NOTIFICATIONS_TITLE,
                    content:
                        AppStrings.INBOX_SYSTEM_NOTIFICATIONS_ACCOUNT_UPDATES,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _zero(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.height * 0.02,
        bottom: context.height * 0.01,
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
}

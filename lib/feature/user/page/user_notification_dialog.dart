import 'package:flutter/material.dart';

import 'user_notification_page.dart';

void dialogUserNotification(
  BuildContext context, {
  required String id,
  required String name,
  required bool isNotificationEnabled,
  required bool isFollowing,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    builder: (context) => UserNotificationPage(
      id: id,
      name: name,
      isFollowing: isFollowing,
      isNotificationEnabled: isNotificationEnabled,
    ),
  );
}

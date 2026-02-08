import 'package:flutter/material.dart';

import '../../../feature/user/page/user_notification_dialog.dart';
import '../../constants/icons.dart';
import 'icon_button.dart';

class UserNotificationButton extends StatelessWidget {
  final String userId;
  final String fullname;
  final bool isNotificationEnabled;
  final bool isFollowing;
  const UserNotificationButton({
    super.key,
    required this.userId,
    required this.fullname,
    required this.isFollowing,
    required this.isNotificationEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return IconButtonComponent(
      icon: AppIcons.NOTIFICATION,
      onTap: () => dialogUserNotification(
        context,
        id: userId,
        name: fullname,
        isFollowing: isFollowing,
        isNotificationEnabled: isNotificationEnabled,
      ),
    );
  }
}

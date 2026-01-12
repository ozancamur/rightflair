import 'package:flutter/material.dart';

import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/icons.dart';
import 'notification_type.dart';

class NotificationConfig {
  final String icon;
  final Color iconColor;
  final Color bgColor;

  NotificationConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  static NotificationConfig getConfig(NotificationType type) {
    switch (type) {
      case NotificationType.trending:
        return NotificationConfig(
          icon: AppIcons.TREND,
          iconColor: AppDarkColors.GREEN,
          bgColor: AppDarkColors.TRANSPARENT_GREEN,
        );
      case NotificationType.like:
        return NotificationConfig(
          icon: AppIcons.LIKED,
          iconColor: AppDarkColors.RED,
          bgColor: AppDarkColors.TRANSPARENT_RED,
        );
      case NotificationType.view:
        return NotificationConfig(
          icon: AppIcons.VIEWED,
          iconColor: AppDarkColors.PURPLE,
          bgColor: AppDarkColors.TRANSPARENT_PURPLE,
        );
      case NotificationType.save:
        return NotificationConfig(
          icon: AppIcons.SAVED,
          iconColor: AppDarkColors.BLUE,
          bgColor: AppDarkColors.TRANSPARENT_BLUE,
        );
      case NotificationType.share:
        return NotificationConfig(
          icon: AppIcons.SHARED,
          iconColor: AppDarkColors.YELLOW,
          bgColor: AppDarkColors.TRANSPARENT_YELLOW,
        );
      case NotificationType.newFollower:
        return NotificationConfig(
          icon: AppIcons.NEW_FOLLOWERS,
          iconColor: Colors.white,
          bgColor: AppDarkColors.BLUE,
        );
      case NotificationType.system:
        return NotificationConfig(
          icon: AppIcons.SYSTEM,
          iconColor: Colors.black,
          bgColor: Colors.white,
        );
    }
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/constants/icons.dart';
import '../../../../../core/extensions/context.dart';
import '../../../../../core/constants/enums/notification_type.dart';

class NotificationConfig {
  final String icon;
  final Color iconColor;
  final Color bgColor;

  NotificationConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  static NotificationConfig getConfig(
    BuildContext context,
    NotificationType? type,
  ) {
    switch (type) {
      case NotificationType.TRENDING_POST:
        return NotificationConfig(
          icon: AppIcons.TREND,
          iconColor: context.colors.inverseSurface,
          bgColor: context.colors.onInverseSurface,
        );
      case NotificationType.MILESTONE_LIKES:
        return NotificationConfig(
          icon: AppIcons.LIKED,
          iconColor: context.colors.error,
          bgColor: context.colors.onError,
        );
      case NotificationType.MILESTONE_VIEWS:
        return NotificationConfig(
          icon: AppIcons.VIEWED,
          iconColor: context.colors.secondaryContainer,
          bgColor: context.colors.onSecondaryContainer,
        );
      case NotificationType.MILESTONE_SAVES:
        return NotificationConfig(
          icon: AppIcons.SAVED,
          iconColor: context.colors.surfaceVariant,
          bgColor: context.colors.onSurfaceVariant,
        );
      case NotificationType.MILESTONE_SHARES:
        return NotificationConfig(
          icon: AppIcons.SHARED,
          iconColor: context.colors.surface,
          bgColor: context.colors.onSurface,
        );
      case NotificationType.NEW_FOLLOWER:
        return NotificationConfig(
          icon: AppIcons.NEW_FOLLOWERS,
          iconColor: Colors.white,
          bgColor: context.colors.surfaceVariant,
        );
      case NotificationType.SYSTEM_UPDATE:
        return NotificationConfig(
          icon: AppIcons.SYSTEM,
          iconColor: context.colors.secondary,
          bgColor: context.colors.primary,
        );

      case NotificationType.LIKE:
        return defaultConfig(context);
      case NotificationType.COMMENT:
        return defaultConfig(context);
      case NotificationType.MENTION:
        return defaultConfig(context);
      case NotificationType.SHARE:
        return defaultConfig(context);
      case NotificationType.RECOMMENDED_USER:
        return defaultConfig(context);
      case NotificationType.ACCOUNT_ALERT:
        return defaultConfig(context);
      case NotificationType.NEW_POST:
        return defaultConfig(context);
      case null:
        return defaultConfig(context);
    }
  }

  static NotificationConfig defaultConfig(BuildContext context) {
    return NotificationConfig(
      icon: AppIcons.NOTIFICATION,
      iconColor: context.colors.primary,
      bgColor: context.colors.secondary,
    );
  }
}

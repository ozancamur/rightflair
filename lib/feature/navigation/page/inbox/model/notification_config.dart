import 'package:flutter/material.dart';

import '../../../../../core/constants/icons.dart';
import '../../../../../core/extensions/context.dart';
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

  static NotificationConfig getConfig(
    BuildContext context,
    NotificationType type,
  ) {
    switch (type) {
      case NotificationType.trending:
        return NotificationConfig(
          icon: AppIcons.TREND,
          iconColor: context.colors.inverseSurface,
          bgColor: context.colors.onInverseSurface,
        );
      case NotificationType.like:
        return NotificationConfig(
          icon: AppIcons.LIKED,
          iconColor: context.colors.error,
          bgColor: context.colors.onError,
        );
      case NotificationType.view:
        return NotificationConfig(
          icon: AppIcons.VIEWED,
          iconColor: context.colors.secondaryContainer,
          bgColor: context.colors.onSecondaryContainer,
        );
      case NotificationType.save:
        return NotificationConfig(
          icon: AppIcons.SAVED,
          iconColor: context.colors.surfaceVariant,
          bgColor: context.colors.onSurfaceVariant,
        );
      case NotificationType.share:
        return NotificationConfig(
          icon: AppIcons.SHARED,
          iconColor: context.colors.surface,
          bgColor: context.colors.onSurface,
        );
      case NotificationType.newFollower:
        return NotificationConfig(
          icon: AppIcons.NEW_FOLLOWERS,
          iconColor: Colors.white,
          bgColor: context.colors.surfaceVariant,
        );
      case NotificationType.system:
        return NotificationConfig(
          icon: AppIcons.SYSTEM,
          iconColor: context.colors.secondary,
          bgColor: context.colors.primary,
        );
    }
  }
}

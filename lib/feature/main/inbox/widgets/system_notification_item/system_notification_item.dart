import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

import 'system_notification_title.dart';

class SystemNotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String description;
  final String timeAgo;

  const SystemNotificationItem({
    super.key,
    required this.title,
    required this.message,
    required this.description,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.height * 0.01),
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        color: context.colors.onSecondary,
        border: Border.all(color: context.colors.onSecondary),
        borderRadius: BorderRadius.circular(context.width * 0.04),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * 0.005,
        children: [
          SystemNotificationTitleWidget(title: title, timeAgo: timeAgo),
          TextComponent(
            text: message,
            size: FontSizeConstants.SMALL,
            weight: FontWeight.w600,
            tr: false,
            color: context.colors.primary,
            maxLine: 2,
          ),
          TextComponent(
            text: description,
            size: FontSizeConstants.X_SMALL,
            color: context.colors.tertiary,
            tr: false,
            height: 1.25,
          ),
        ],
      ),
    );
  }
}

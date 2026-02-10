import 'package:flutter/material.dart';

import '../../../../../core/components/text/text.dart';
import '../../../../../core/constants/font/font_size.dart';
import '../../../../../core/extensions/context.dart';
import 'system_notification_icon.dart';

class SystemNotificationTitleWidget extends StatelessWidget {
  final String title;
  final String timeAgo;
  const SystemNotificationTitleWidget({
    super.key,
    required this.title,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .05,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: context.width * 0.03,
        children: [
          const SystemNotificationIconWidget(),
          Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerLeft,
              child: TextComponent(
                text: title,
                size: FontSizeConstants.SMALL,
                weight: FontWeight.w500,
                tr: false,
                color: context.colors.primary,
              ),
            ),
          ),
          TextComponent(
            text: '• $timeAgo',
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

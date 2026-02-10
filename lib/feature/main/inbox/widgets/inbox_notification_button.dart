import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../../../../core/extensions/context.dart';
import '../../../../../core/constants/enums/notification_type.dart';
import 'notifications/notification_item.dart';

class InboxNotificationButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final NotificationType type;
  final String title;
  final String content;
  const InboxNotificationButtonWidget({
    super.key,
    required this.onTap,
    required this.type,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.height * 0.0075),
        padding: EdgeInsets.symmetric(
          horizontal: context.width * .04,
          vertical: context.width * 0.03,
        ),
        decoration: BoxDecoration(
          color: context.colors.onBackground,
          borderRadius: BorderRadius.circular(context.width * 0.04),
        ),
        child: Row(
          spacing: context.width * 0.04,
          children: [
            NotificationItemWidget(type: type),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComponent(
                    text: title,
                    size: FontSizeConstants.SMALL,
                    weight: FontWeight.w500,
                    maxLine: 2,
                    color: context.colors.primary,
                  ),
                  SizedBox(height: context.height * 0.005),
                  TextComponent(
                    text: content,
                    size: FontSizeConstants.XX_SMALL,
                    color: context.colors.primary,
                    overflow: TextOverflow.ellipsis,
                    maxLine: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/notification_type.dart';
import 'notification_item.dart';

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
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(context.width * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NotificationItemWidget(type: NotificationType.system),
              SizedBox(width: context.width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComponent(
                      text: title,
                      size: FontSizeConstants.SMALL,
                      weight: FontWeight.w600,
                      tr: false,
                    ),
                    SizedBox(height: context.height * 0.005),
                    TextComponent(
                      text: message,
                      size: FontSizeConstants.XX_SMALL,
                      color: AppDarkColors.GREY,
                      tr: false,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: AppDarkColors.PRIMARY,
                  size: context.width * 0.06,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: context.height * 0.015),
          TextComponent(
            text: description,
            size: FontSizeConstants.XX_SMALL,
            color: AppDarkColors.GREY,
            tr: false,
            maxLine: 3,
          ),
          SizedBox(height: context.height * 0.01),
          Row(
            children: [
              TextComponent(
                text: '• $timeAgo',
                size: FontSizeConstants.XXX_SMALL,
                color: AppDarkColors.GREY,
                tr: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

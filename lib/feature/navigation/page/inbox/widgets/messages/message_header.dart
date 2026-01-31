import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../../../../../core/components/text/text.dart';
import '../../../../../../core/extensions/context.dart';
import '../../../../../../core/constants/string.dart';

class MessageHeaderWidget extends StatelessWidget {
  final String senderName;
  final DateTime timestamp;
  const MessageHeaderWidget({
    super.key,
    required this.senderName,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextComponent(
            text: senderName,
            size: FontSizeConstants.LARGE,
            weight: FontWeight.w600,
            color: context.colors.primary,
            tr: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8),
        TextComponent(
          text: _formatTime(context, timestamp),
          size: const [12],
          color: context.colors.scrim,
          tr: false,
        ),
      ],
    );
  }

  String _formatTime(BuildContext context, DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}${AppStrings.TIME_MINUTES_AGO.tr()}';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}${AppStrings.TIME_HOURS_AGO.tr()}';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}${AppStrings.TIME_DAYS_AGO.tr()}';
    }
    if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}${AppStrings.TIME_WEEKS_AGO.tr()}';
    }
    if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}${AppStrings.TIME_MONTHS_AGO.tr()}';
    }
    return '${(diff.inDays / 365).floor()}${AppStrings.TIME_YEARS_AGO.tr()}';
  }
}

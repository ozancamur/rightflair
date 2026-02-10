import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../../../../core/components/text/text.dart';
import '../../../../../core/extensions/context.dart';

class MessageHeaderWidget extends StatelessWidget {
  final String senderName;
  final DateTime timestamp;
  final bool isRead;
  const MessageHeaderWidget({
    super.key,
    required this.senderName,
    required this.timestamp,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    String date = _formatTime(context, timestamp);
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
        TextComponent(
          text: date,
          size: FontSizeConstants.X_SMALL,
          color: context.colors.scrim,
          tr: false,
        ),
      ],
    );
  }

  String _formatTime(BuildContext context, DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    // Bugün mü kontrol et
    if (now.year == time.year &&
        now.month == time.month &&
        now.day == time.day) {
      return DateFormat('HH:mm').format(time);
    }

    // Bu hafta içinde mi (son 7 gün)
    if (diff.inDays < 7) {
      return DateFormat('EEEE', context.locale.toString()).format(time);
    }

    // 1 haftadan fazla
    return DateFormat('dd.MM.yyyy').format(time);
  }
}

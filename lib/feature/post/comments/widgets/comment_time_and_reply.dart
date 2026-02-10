import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/helpers/date.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/extensions/context.dart';

class CommentTimeAndReplyWidget extends StatelessWidget {
  final DateTime createdAt;
  final VoidCallback onReply;
  final bool canReply;
  const CommentTimeAndReplyWidget({
    super.key,
    required this.createdAt,
    required this.onReply,
    required this.canReply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.width * 0.03,
      children: [_timeAgo(context), if (canReply) _reply(context)],
    );
  }

  GestureDetector _reply(BuildContext context) {
    return GestureDetector(
      onTap: onReply,
      child: TextComponent(
        text: AppStrings.COMMENTS_REPLY,
        color: context.colors.primary.withOpacity(0.5),
        size: FontSizeConstants.XX_SMALL,
        weight: FontWeight.w600,
      ),
    );
  }

  TextComponent _timeAgo(BuildContext context) {
    return TextComponent(
      text: DateHelper.timeAgo(createdAt),
      color: context.colors.primary.withOpacity(0.5),
      size: FontSizeConstants.XX_SMALL,
      tr: false,
    );
  }
}

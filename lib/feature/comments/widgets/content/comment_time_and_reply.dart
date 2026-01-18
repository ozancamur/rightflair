import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../core/extensions/context.dart';

class CommentTimeAndReplyWidget extends StatelessWidget {
  final String timeAgo;
  const CommentTimeAndReplyWidget({super.key, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          timeAgo,
          style: TextStyle(
            color: context.colors.primary.withOpacity(0.5),
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            // Handle reply
          },
          child: Text(
            AppStrings.COMMENTS_REPLY.tr(),
            style: TextStyle(
              color: context.colors.primary.withOpacity(0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

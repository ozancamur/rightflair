import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../core/extensions/context.dart';

class CommentRepliesButtonWidget extends StatelessWidget {
  final int replyCount;
  final VoidCallback onTap;
  final bool isExpanded;
  const CommentRepliesButtonWidget({
    super.key,
    required this.replyCount,
    required this.onTap,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          spacing: context.width * 0.01,
          children: [
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: context.colors.primary.withOpacity(0.7),
              size: context.width * 0.04,
            ),
            TextComponent(
              text: AppStrings.COMMENTS_VIEW_REPLIES.tr(
                args: [replyCount.toString()],
              ),
              color: context.colors.primary.withOpacity(0.7),
              size: FontSizeConstants.X_SMALL,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

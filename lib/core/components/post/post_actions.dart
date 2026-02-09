import 'package:flutter/material.dart';

import '../../constants/icons.dart';
import '../../extensions/context.dart';
import 'post_action_icon.dart';

class PostActionsComponent extends StatelessWidget {
  final String postId;
  final int comment;
  final int saved;
  final int shared;
  final VoidCallback onComment;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final bool isSaved;
  const PostActionsComponent({
    super.key,
    required this.postId,
    required this.comment,
    required this.saved,
    required this.shared,
    required this.onComment,
    required this.onSave,
    required this.onShare,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: context.width * .04,
      bottom: context.width * .08,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: context.height * .01,
        children: [
          PostIconButtonWidget(
            onTap: onComment,
            icon: AppIcons.MESSAGE_FILLED,
            value: comment,
          ),
          PostIconButtonWidget(
            onTap: onSave,
            icon: AppIcons.SAVE_FILLED,
            value: saved,
            isActive: isSaved,
          ),
          PostIconButtonWidget(
            onTap: onShare,
            icon: AppIcons.SHARE_FILLED,
            value: shared,
          ),
        ],
      ),
    );
  }
}

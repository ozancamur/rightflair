import 'package:flutter/material.dart';

import '../../../core/extensions/context.dart';
import '../../main/feed/models/comment.dart';
import 'comment_avatar.dart';
import 'comment_content.dart';
import 'comment_like_button.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  final Function(String commentId) onReply;
  final bool canReply;
  const CommentWidget({
    super.key,
    required this.comment,
    required this.onReply,
    this.canReply = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommentAvatarWidget(
                avatar: comment.user?.profilePhotoUrl,
                username: comment.user?.username ?? "rightflair_user",
              ),
              SizedBox(width: context.width * 0.03),
              CommentContentWidget(
                comment: comment,
                onReply: onReply,
                canReply: canReply,
              ),
              CommentLikeButtonWidget(
                isLiked: comment.isLiked ?? false,
                likeCount: comment.likesCount ?? 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

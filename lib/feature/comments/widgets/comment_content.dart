import 'package:flutter/material.dart';

import '../model/comment.dart';
import 'content/comment_replies_button.dart';
import 'content/comment_text.dart';
import 'content/comment_time_and_reply.dart';
import 'content/comment_username.dart';

class CommentContentWidget extends StatelessWidget {
  final CommentModel comment;
  const CommentContentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username
          CommentUsernameWidget(username: comment.userName),
          const SizedBox(height: 4),

          // Comment Text
          CommentTextWidget(text: comment.text),

          const SizedBox(height: 8),

          // Time and Reply
          CommentTimeAndReplyWidget(timeAgo: comment.timeAgo),

          // View Replies Button
          if (comment.replyCount > 0)
            CommentRepliesButtonWidget(replyCount: comment.replyCount),
        ],
      ),
    );
  }
}

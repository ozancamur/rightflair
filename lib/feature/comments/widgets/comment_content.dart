import 'package:flutter/material.dart';

import '../../../core/extensions/context.dart';
import '../../navigation/page/feed/models/comment.dart';
import 'comment.dart';
import 'content/comment_replies_button.dart';
import 'content/comment_text.dart';
import 'content/comment_time_and_reply.dart';
import 'content/comment_username.dart';

class CommentContentWidget extends StatefulWidget {
  final CommentModel comment;
  const CommentContentWidget({super.key, required this.comment});

  @override
  State<CommentContentWidget> createState() => _CommentContentWidgetState();
}

class _CommentContentWidgetState extends State<CommentContentWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username
          CommentUsernameWidget(
            username: widget.comment.user?.username ?? "rightflair_user",
          ),
          SizedBox(height: context.width * 0.005),

          // Comment Text
          CommentTextWidget(text: widget.comment.content ?? ""),

          SizedBox(height: context.width * 0.01),

          // Time and Reply
          CommentTimeAndReplyWidget(
            createdAt: widget.comment.createdAt ?? DateTime.now(),
          ),

          // View Replies Button
          if ((widget.comment.repliesCount ?? 0) > 0) ...[
            CommentRepliesButtonWidget(
              replyCount: widget.comment.repliesCount ?? 0,
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              isExpanded: _isExpanded,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.topCenter,
              child: _isExpanded && widget.comment.replies != null
                  ? Column(
                      children: widget.comment.replies!
                          .map(
                            (reply) => Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: CommentWidget(
                                comment: CommentModel(
                                  id: reply.id,
                                  content: reply.content,
                                  createdAt: reply.createdAt,
                                  likesCount: reply.likesCount,
                                  user: reply.user,
                                  isLiked: reply.isLiked,
                                  replies: [],
                                  repliesCount: 0,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }
}

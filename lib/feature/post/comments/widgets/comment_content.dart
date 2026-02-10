import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../../main/feed/models/comment.dart';
import 'comment.dart';
import 'comment_replies_button.dart';
import 'comment_text.dart';
import 'comment_time_and_reply.dart';
import 'comment_username.dart';

class CommentContentWidget extends StatefulWidget {
  final CommentModel comment;
  final Function(String commentId) onReply;
  final bool canReply;
  const CommentContentWidget({
    super.key,
    required this.comment,
    required this.onReply,
    required this.canReply,
  });

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
          CommentUsernameWidget(
            username: widget.comment.user?.username ?? "rightflair_user",
          ),
          SizedBox(height: context.width * 0.005),
          CommentTextWidget(text: widget.comment.content ?? ""),
          SizedBox(height: context.width * 0.01),
          CommentTimeAndReplyWidget(
            createdAt: widget.comment.createdAt ?? DateTime.now(),
            onReply: () => widget.onReply(widget.comment.id ?? ""),
            canReply: widget.canReply,
          ),
          if ((widget.comment.repliesCount ?? 0) > 0) ...[
            _button(),
            _replies(),
          ],
        ],
      ),
    );
  }

  CommentRepliesButtonWidget _button() {
    return CommentRepliesButtonWidget(
      replyCount: widget.comment.repliesCount ?? 0,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      isExpanded: _isExpanded,
    );
  }

  AnimatedSize _replies() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      child: _isExpanded && widget.comment.replies != null
          ? Column(
              children: widget.comment.replies!
                  .map(
                    (reply) => Padding(
                      padding: EdgeInsets.only(top: context.width * 0.01),
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
                        onReply: widget.onReply,
                        canReply: false,
                      ),
                    ),
                  )
                  .toList(),
            )
          : const SizedBox.shrink(),
    );
  }
}

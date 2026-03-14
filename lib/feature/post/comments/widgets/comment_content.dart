import 'package:flutter/material.dart';

import '../../../../core/components/loading.dart';
import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../../main/feed/models/comment.dart';
import 'comment.dart';
import 'comment_replies_button.dart';
import 'comment_text.dart';
import 'comment_time_and_reply.dart';
import 'comment_username.dart';

class CommentContentWidget extends StatefulWidget {
  final CommentModel comment;
  final String displayText;
  final bool isTranslating;
  final bool showTranslated;
  final VoidCallback? onTranslate;
  final Function(String commentId) onReply;
  final Function(String commentId)? onLike;
  final bool canReply;
  const CommentContentWidget({
    super.key,
    required this.comment,
    required this.displayText,
    this.isTranslating = false,
    this.showTranslated = false,
    this.onTranslate,
    required this.onReply,
    this.onLike,
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
          widget.isTranslating
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: context.width * 0.01),
                  child: SizedBox(
                    height: context.width * 0.04,
                    width: context.width * 0.04,
                    child: const LoadingComponent(),
                  ),
                )
              : CommentTextWidget(text: widget.displayText),
          if (widget.onTranslate != null && !widget.isTranslating)
            GestureDetector(
              onTap: widget.onTranslate,
              child: Padding(
                padding: EdgeInsets.only(top: context.width * 0.01),
                child: TextComponent(
                  text: widget.showTranslated
                      ? AppStrings.COMMENTS_SEE_ORIGINAL
                      : AppStrings.COMMENTS_TRANSLATE,
                  size: FontSizeConstants.SMALL,
                  color: context.colors.primaryContainer,
                  weight: FontWeight.w500,
                ),
              ),
            ),
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
                        onLike: reply.id != null && widget.onLike != null
                            ? () => widget.onLike!(reply.id!)
                            : null,
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

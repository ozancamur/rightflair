import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context.dart';
import '../../../main/feed/models/comment.dart';
import 'comment_avatar.dart';
import 'comment_content.dart';
import 'comment_like_button.dart';
import 'comment_options_popup.dart';
import 'comment_report_page.dart';
import 'comment_translate_dialog.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel comment;
  final Function(String commentId) onReply;
  final VoidCallback? onLike;
  final bool canReply;
  const CommentWidget({
    super.key,
    required this.comment,
    required this.onReply,
    this.onLike,
    this.canReply = true,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        _animController.forward();
        HapticFeedback.mediumImpact();
      },
      onLongPress: () {
        _animController.reverse();
        _showOptions(context);
      },
      onLongPressCancel: () => _animController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentAvatarWidget(
                    avatar: widget.comment.user?.profilePhotoUrl,
                    username:
                        widget.comment.user?.username ?? "rightflair_user",
                  ),
                  SizedBox(width: context.width * 0.03),
                  CommentContentWidget(
                    comment: widget.comment,
                    onReply: widget.onReply,
                    onLike: widget.onLike != null && widget.comment.id != null
                        ? (_) => widget.onLike!()
                        : null,
                    canReply: widget.canReply,
                  ),
                  CommentLikeButtonWidget(
                    isLiked: widget.comment.isLiked ?? false,
                    likeCount: widget.comment.likesCount ?? 0,
                    onLike: widget.onLike,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    CommentOptionsPopup.show(
      context,
      onTranslate: () {
        final text = widget.comment.content ?? '';
        if (text.isNotEmpty) {
          CommentTranslateDialog.show(context, originalText: text);
        }
      },
      onReport: () {
        if (widget.comment.id != null) {
          CommentReportPage.show(context, commentId: widget.comment.id!);
        }
      },
    );
  }
}

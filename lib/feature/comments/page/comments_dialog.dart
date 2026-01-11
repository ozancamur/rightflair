import 'package:flutter/material.dart';
import 'package:rightflair/feature/comments/widgets/add_comment.dart';

import '../model/comment.dart';
import '../../../core/components/drag_handle.dart';
import '../widgets/comments_header.dart';
import '../widgets/comments_list.dart';

class CommentsDialog extends StatelessWidget {
  final List<CommentModel> comments;
  final Function(String) onAddComment;

  const CommentsDialog({
    super.key,
    required this.comments,
    required this.onAddComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          const DragHandleComponent(),

          // Header
          CommentsHeaderWidget(commentCount: comments.length),

          // Divider
          Container(height: 1, color: Colors.white.withOpacity(0.1)),

          // Comments List
          CommentsListWidget(list: comments),

          // Add Comment Section
          AddCommentWidget(onAddComment: onAddComment),
        ],
      ),
    );
  }
}

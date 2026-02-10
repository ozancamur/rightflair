import 'package:flutter/material.dart';

import '../../main/feed/models/comment.dart';
import 'comment.dart';

class CommentsListWidget extends StatefulWidget {
  final List<CommentModel> comments;
  final Function(String commentId) onReply;
  const CommentsListWidget({
    super.key,
    required this.comments,
    required this.onReply,
  });

  @override
  State<CommentsListWidget> createState() => _CommentsListWidgetState();
}

class _CommentsListWidgetState extends State<CommentsListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          final CommentModel comment = widget.comments[index];
          return CommentWidget(comment: comment, onReply: widget.onReply);
        },
      ),
    );
  }
}

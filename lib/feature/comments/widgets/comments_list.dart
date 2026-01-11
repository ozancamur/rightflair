import 'package:flutter/material.dart';

import '../model/comment.dart';
import 'comment.dart';

class CommentsListWidget extends StatelessWidget {
  final List<CommentModel> list;
  CommentsListWidget({super.key, required this.list});
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final comment = list[index];
          return CommentWidget(comment: comment);
        },
      ),
    );
  }
}

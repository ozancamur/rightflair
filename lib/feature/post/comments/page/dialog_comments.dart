import 'package:flutter/material.dart';

import 'comments_dialog_page.dart';

void dialogComments(
  BuildContext context, {
  required String postId,
  required VoidCallback onAddComment,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    builder: (context) =>
        CommentsDialogPage(postId: postId, onAddComment: onAddComment),
  ).whenComplete(() {
    if (context.mounted) {
      FocusScope.of(context).unfocus();
    }
  });
}

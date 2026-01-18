import 'package:flutter/material.dart';
import '../../../../../../core/extensions/context.dart';
import '../../model/comment.dart';
import 'inbox_message_item.dart';

class InboxMessagesListWidget extends StatelessWidget {
  final List<CommentModel> messages;
  const InboxMessagesListWidget({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: context.height * 0.02,
        horizontal: context.width * .03,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return InboxMessageItem(message: messages[index]);
      },
    );
  }
}

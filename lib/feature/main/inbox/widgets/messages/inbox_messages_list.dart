import 'package:flutter/material.dart';
import '../../../../../core/extensions/context.dart';
import '../../model/conversation.dart';
import 'inbox_message_item.dart';

class InboxMessagesListWidget extends StatelessWidget {
  final List<ConversationModel> list;
  const InboxMessagesListWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: context.height * 0.02,
        horizontal: context.width * .03,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final ConversationModel conversation = list[index];
        return InboxMessageItem(conversation: conversation);
      },
    );
  }
}

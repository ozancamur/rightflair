import 'package:flutter/material.dart';
import '../../../../../../core/extensions/context.dart';
import '../../model/conversation.dart';
import '../../model/conversations.dart';
import 'inbox_message_item.dart';

class InboxMessagesListWidget extends StatelessWidget {
  final ConversationsModel data;
  const InboxMessagesListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: context.height * 0.02,
        horizontal: context.width * .03,
      ),
      itemCount: data.conversations?.length ?? 0,
      itemBuilder: (context, index) {
        final ConversationModel conversation = data.conversations![index];
        return InboxMessageItem(conversation: conversation);
      },
    );
  }
}

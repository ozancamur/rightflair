import 'package:flutter/material.dart';
import '../../model/message.dart';
import 'inbox_message_item.dart';

class InboxMessagesListWidget extends StatelessWidget {
  final List<MessageModel> messages;
  const InboxMessagesListWidget({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return InboxMessageItem(message: messages[index]);
      },
    );
  }
}

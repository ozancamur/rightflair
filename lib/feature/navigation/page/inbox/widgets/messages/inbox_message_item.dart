import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context.dart';
import '../../model/message.dart';
import 'message_avatar.dart';
import 'message_content.dart';
import 'message_header.dart';

class InboxMessageItem extends StatelessWidget {
  final MessageModel message;

  const InboxMessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Row(
          spacing: context.width * 0.03,
          children: [
            MessageAvatarWidget(url: message.image ?? ""),
            _detail(context),
          ],
        ),
      ),
    );
  }

  Expanded _detail(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageHeaderWidget(
            senderName: message.ownerId ?? "",
            timestamp: message.createdAt ?? DateTime.now(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          MessageContentWidget(lastMessage: message.message ?? ""),
        ],
      ),
    );
  }
}

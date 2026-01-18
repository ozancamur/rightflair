import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context.dart';
import '../../model/comment.dart';
import 'message_avatar.dart';
import 'message_content.dart';
import 'message_header.dart';

class InboxMessageItem extends StatelessWidget {
  final CommentModel message;

  const InboxMessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border(
            bottom: BorderSide(
              color: context.colors.primary.withOpacity(.25),
              width: .5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../../../core/extensions/context.dart';
import '../../model/conversation.dart';
import '../../model/last_message.dart';
import 'message_avatar.dart';
import 'message_content.dart';
import 'message_header.dart';

class InboxMessageItem extends StatelessWidget {
  final ConversationModel conversation;

  const InboxMessageItem({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          RouteConstants.CHAT,
          extra: {
            'conversationId': conversation.id ?? '',
            'otherUserName': conversation.participant?.fullName ?? 'User',
            'otherUserPhoto': conversation.participant?.profilePhotoUrl,
            'otherUserId': conversation.participant?.id ?? '',
          },
        );
      },
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
            MessageAvatarWidget(
              url: conversation.participant?.profilePhotoUrl ?? "",
            ),
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
        spacing: context.height * 0.005,
        children: [
          MessageHeaderWidget(
            senderName: conversation.participant?.fullName ?? "Rightflair User",
            timestamp: conversation.lastMessage?.sentAt ?? DateTime.now(),
            isRead: conversation.lastMessage?.isRead ?? true,
          ),
          MessageContentWidget(
            model: conversation.lastMessage ?? LastMessageModel(),
          ),
        ],
      ),
    );
  }
}

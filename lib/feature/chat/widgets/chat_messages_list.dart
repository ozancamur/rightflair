import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/chat/model/chat_message.dart';
import 'package:rightflair/feature/chat/widgets/message_bubble.dart';

class ChatMessagesListWidget extends StatefulWidget {
  final List<ChatMessageModel> messages;
  final ScrollController scrollController;
  const ChatMessagesListWidget({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  State<ChatMessagesListWidget> createState() => _ChatMessagesListWidgetState();
}

class _ChatMessagesListWidgetState extends State<ChatMessagesListWidget> {



  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return Center(
        child: TextComponent(
          text: AppStrings.CHAT_NO_MESSAGES,
          size: FontSizeConstants.NORMAL,
          color: context.colors.tertiary,
        ),
      );
    }

    return ListView.builder(
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.02,
      ),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final isNextMessageSameSender =
            index < widget.messages.length - 1 &&
            widget.messages[index + 1].isOwnMessage == message.isOwnMessage;

        return MessageBubbleWidget(
          message: message,
          isNextMessageSameSender: isNextMessageSameSender,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/chat/model/chat_message.dart';
import 'package:rightflair/feature/chat/widgets/message_bubble.dart';

class ChatMessagesListWidget extends StatefulWidget {
  final List<ChatMessageModel> messages;

  const ChatMessagesListWidget({super.key, required this.messages});

  @override
  State<ChatMessagesListWidget> createState() => _ChatMessagesListWidgetState();
}

class _ChatMessagesListWidgetState extends State<ChatMessagesListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _initialScrollDone = false;

  @override
  void didUpdateWidget(ChatMessagesListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Scroll to bottom on initial load
    if (!_initialScrollDone && widget.messages.isNotEmpty) {
      _initialScrollDone = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
    // Scroll to bottom when new message is added
    else if (widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      controller: _scrollController,
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

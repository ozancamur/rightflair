import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/chat/cubit/chat_cubit.dart';
import 'package:rightflair/feature/chat/model/chat_message.dart';
import 'package:rightflair/feature/chat/widgets/chat_message/message_content.dart';

import '../../../core/constants/enums/message_send_status.dart';
import 'chat_message/message_avatar.dart';
import 'chat_message/message_is_read_indicator.dart';
import 'chat_message/message_time.dart';

class MessageBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;
  final bool isNextMessageSameSender;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isNextMessageSameSender,
  });

  @override
  Widget build(BuildContext context) {
    final isOwnMessage = message.isOwnMessage ?? false;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isNextMessageSameSender
            ? context.height * 0.004
            : context.height * 0.012,
      ),
      child: Row(
        mainAxisAlignment: isOwnMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOwnMessage) ...[
            MessageAvatar(
              isNextMessageSameSender: isNextMessageSameSender,
              profilePhotoUrl: message.sender?.profilePhotoUrl,
            ),
            SizedBox(width: context.width * 0.02),
          ],
          _content(isOwnMessage, context),
          if (isOwnMessage) ...[
            SizedBox(width: context.width * 0.02),
            if (message.sendStatus == MessageSendStatus.failed)
              _failedIndicator(context)
            else
              MessageIsReadIndicatorWidget(
                isNextMessageSameSender: isNextMessageSameSender,
                isRead: message.isRead,
              ),
          ],
        ],
      ),
    );
  }

  Widget _failedIndicator(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFailedMessageOptions(context),
      child: Container(
        width: context.width * 0.05,
        height: context.width * 0.05,
        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: Icon(
          Icons.priority_high,
          color: Colors.white,
          size: context.width * 0.035,
        ),
      ),
    );
  }

  void _showFailedMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.refresh, color: context.colors.primary),
                  title: Text(
                    'Tekrar Gönder',
                    style: TextStyle(color: context.colors.primary),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<ChatCubit>().resendMessage(message);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    'Mesajı Sil',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<ChatCubit>().deleteFailedMessage(message.id!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Flexible _content(bool isOwnMessage, BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: isOwnMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          MessageContentWidget(
            isOwnMessage: isOwnMessage,
            imageUrl: message.imageUrl,
            content: message.content,
          ),
          if (!isNextMessageSameSender) ...[
            SizedBox(height: context.height * 0.003),
            MessageTimeWidget(createdAt: message.createdAt),
          ],
        ],
      ),
    );
  }
}

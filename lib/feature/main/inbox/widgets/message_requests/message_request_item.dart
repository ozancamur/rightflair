import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/components/text/text.dart';
import '../../../../../core/constants/font/font_size.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';
import '../../cubit/inbox_cubit.dart';
import '../../model/message_request.dart';
import '../messages/message_avatar.dart';

class MessageRequestItem extends StatelessWidget {
  final MessageRequestModel request;

  const MessageRequestItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.height * 0.015,
        horizontal: context.width * 0.05,
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
        spacing: context.width * 0.03,
        children: [
          MessageAvatarWidget(
            id: request.sender?.id,
            url: request.sender?.profilePhotoUrl ?? "",
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: context.height * 0.004,
              children: [
                TextComponent(
                  text:
                      request.sender?.fullName ??
                      request.sender?.username ??
                      'User',
                  size: FontSizeConstants.NORMAL,
                  color: context.colors.primary,
                  weight: FontWeight.w600,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  tr: false,
                ),
                TextComponent(
                  text: request.lastMessagePreview ?? '',
                  size: FontSizeConstants.SMALL,
                  color: context.colors.tertiary,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  tr: false,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: context.width * 0.02,
            children: [
              _ActionButton(
                label: AppStrings.INBOX_ACCEPT.tr(),
                color: context.colors.primary,
                textColor: context.colors.secondary,
                onTap: () {
                  context.read<InboxCubit>().acceptMessageRequest(
                    conversationId: request.conversationId ?? '',
                    context: context,
                  );
                },
              ),
              _ActionButton(
                label: AppStrings.INBOX_DECLINE.tr(),
                color: context.colors.secondary,
                textColor: context.colors.primary,
                borderColor: context.colors.primary.withOpacity(.3),
                onTap: () {
                  context.read<InboxCubit>().declineMessageRequest(
                    conversationId: request.conversationId ?? '',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.03,
          vertical: context.height * 0.007,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: FontSizeConstants.X_SMALL.first,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

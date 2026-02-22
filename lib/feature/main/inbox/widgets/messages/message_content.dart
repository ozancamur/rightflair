import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/enums/message_type.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/main/inbox/model/last_message.dart';

import '../../../../../core/components/text/text.dart';

class MessageContentWidget extends StatelessWidget {
  final LastMessageModel model;
  const MessageContentWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final String text = model.messageType == MessageType.post_share.name
        ? AppStrings.INBOX_POST_SHARED.tr()
        : model.messageType == MessageType.profile_share.name
        ? AppStrings.INBOX_PROFILE_SHARED.tr()
        : model.messageType == MessageType.image.name
        ? AppStrings.INBOX_IMAGE_SHARED.tr()
        : model.content ?? "";
    return Row(
      children: [
        Expanded(
          child: TextComponent(
            text: text,
            size: FontSizeConstants.SMALL,
            color: context.colors.tertiary,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
            tr: false,
          ),
        ),
        (model.isOwnMessage == false && model.isRead == false)
            ? Container(
                width: context.width * .02,
                height: context.width * .02,
                decoration: BoxDecoration(
                  color: context.colors.scrim,
                  shape: BoxShape.circle,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

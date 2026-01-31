import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/last_message.dart';

import '../../../../../../core/components/text/text.dart';

class MessageContentWidget extends StatelessWidget {
  final LastMessageModel model;
  const MessageContentWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextComponent(
            text: model.content ?? "",
            size: FontSizeConstants.SMALL,
            color: context.colors.tertiary,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        (model.isOwnMessage == false || model.isRead == false)
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

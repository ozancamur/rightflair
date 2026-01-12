import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../../core/components/text.dart';
import '../../../../../../core/constants/dark_color.dart';

class MessageContentWidget extends StatelessWidget {
  final String lastMessage;
  final bool isRead;
  const MessageContentWidget({
    super.key,
    required this.lastMessage,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextComponent(
            text: lastMessage,
            size: FontSizeConstants.SMALL,
            color: AppDarkColors.GREY,
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!isRead)
          Container(
            width: context.width * .02,
            height: context.width * .02,
            decoration: BoxDecoration(
              color: AppDarkColors.ORANGE,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

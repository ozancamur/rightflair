import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/extensions/context.dart';
import '../../model/message_sender.dart';

class MessageProfileShareWidget extends StatelessWidget {
  final bool isOwnMessage;
  final MessageSenderModel referencedUser;
  final String? content;

  const MessageProfileShareWidget({
    super.key,
    required this.isOwnMessage,
    required this.referencedUser,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.USER, extra: referencedUser.id),
      child: Container(
        constraints: BoxConstraints(maxWidth: context.width * 0.7),
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.04,
          vertical: context.height * 0.012,
        ),
        decoration: BoxDecoration(
          color: isOwnMessage
              ? context.colors.surface
              : context.colors.tertiaryFixedDim,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.width * 0.04),
            topRight: Radius.circular(context.width * 0.04),
            bottomLeft: Radius.circular(
              isOwnMessage ? context.width * 0.04 : context.width * 0.01,
            ),
            bottomRight: Radius.circular(
              isOwnMessage ? context.width * 0.01 : context.width * 0.04,
            ),
          ),
          border: !isOwnMessage
              ? Border.all(
                  color: context.colors.primary.withOpacity(0.2),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (referencedUser.profilePhotoUrl != null &&
                    referencedUser.profilePhotoUrl!.isNotEmpty)
                  CircleAvatar(
                    radius: context.width * 0.05,
                    backgroundImage: CachedNetworkImageProvider(
                      referencedUser.profilePhotoUrl!,
                    ),
                  )
                else
                  CircleAvatar(
                    radius: context.width * 0.05,
                    backgroundColor: context.colors.primary.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: context.width * 0.05,
                      color: context.colors.primary,
                    ),
                  ),
                SizedBox(width: context.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextComponent(
                        text: referencedUser.username ?? '',
                        tr: false,
                        size: FontSizeConstants.NORMAL,
                        weight: FontWeight.w600,
                        color: context.colors.primary,
                      ),
                      if (referencedUser.fullName != null &&
                          referencedUser.fullName!.isNotEmpty)
                        TextComponent(
                          text: referencedUser.fullName!,
                          tr: false,
                          size: FontSizeConstants.SMALL,
                          color: context.colors.primary.withOpacity(0.7),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (content != null && content!.isNotEmpty) ...[
              SizedBox(height: context.height * 0.008),
              TextComponent(
                text: content!,
                tr: false,
                size: FontSizeConstants.NORMAL,
                color: context.colors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/extensions/context.dart';
import '../../cubit/chat_cubit.dart';
import '../../model/referenced_post.dart';

class MessagePostShareWidget extends StatelessWidget {
  final bool isOwnMessage;
  final ReferencedPostModel referencedPost;
  final String? content;

  const MessagePostShareWidget({
    super.key,
    required this.isOwnMessage,
    required this.referencedPost,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<ChatCubit>().getPost(context, pId: referencedPost.id),
      child: Container(
        constraints: BoxConstraints(maxWidth: context.width * 0.7),
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
            // Post image
            if (referencedPost.postImageUrl != null &&
                referencedPost.postImageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.width * 0.04),
                  topRight: Radius.circular(context.width * 0.04),
                ),
                child: CachedNetworkImage(
                  imageUrl: referencedPost.postImageUrl!,
                  width: context.width * 0.7,
                  height: context.width * 0.5,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: context.width * 0.7,
                    height: context.width * 0.5,
                    color: context.colors.primary.withOpacity(0.1),
                    child: Center(
                      child: SizedBox(
                        width: context.width * 0.05,
                        height: context.width * 0.05,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: context.width * 0.7,
                    height: context.width * 0.5,
                    color: context.colors.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: context.colors.primary.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

            // Post info (user + description)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.03,
                vertical: context.height * 0.008,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post owner info
                  if (referencedPost.user != null)
                    Row(
                      children: [
                        if (referencedPost.user!.profilePhotoUrl != null &&
                            referencedPost.user!.profilePhotoUrl!.isNotEmpty)
                          CircleAvatar(
                            radius: context.width * 0.03,
                            backgroundImage: CachedNetworkImageProvider(
                              referencedPost.user!.profilePhotoUrl!,
                            ),
                          )
                        else
                          CircleAvatar(
                            radius: context.width * 0.03,
                            backgroundColor: context.colors.primary.withOpacity(
                              0.2,
                            ),
                            child: Icon(
                              Icons.person,
                              size: context.width * 0.03,
                              color: context.colors.primary,
                            ),
                          ),
                        SizedBox(width: context.width * 0.02),
                        Expanded(
                          child: TextComponent(
                            text: referencedPost.user!.username ?? '',
                            tr: false,
                            size: FontSizeConstants.SMALL,
                            weight: FontWeight.w600,
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),

                  // Post description
                  if (referencedPost.description != null &&
                      referencedPost.description!.isNotEmpty) ...[
                    SizedBox(height: context.height * 0.004),
                    TextComponent(
                      text: referencedPost.description!,
                      tr: false,
                      size: FontSizeConstants.X_SMALL,
                      color: context.colors.primary.withOpacity(0.7),
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Optional content/note from sender
            if (content != null && content!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: context.width * 0.03,
                  right: context.width * 0.03,
                  bottom: context.height * 0.008,
                ),
                child: TextComponent(
                  text: content!,
                  tr: false,
                  size: FontSizeConstants.NORMAL,
                  color: context.colors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

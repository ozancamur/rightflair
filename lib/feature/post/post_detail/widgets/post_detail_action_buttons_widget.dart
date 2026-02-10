import 'package:flutter/material.dart';
import 'package:rightflair/core/components/button/icon_button.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

class PostDetailActionButtonsWidget extends StatelessWidget {
  final int commentsCount;
  final int bookmarkedCount;
  final int sharesCount;
  final VoidCallback onCommentTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback onShareTap;

  const PostDetailActionButtonsWidget({
    super.key,
    required this.commentsCount,
    required this.bookmarkedCount,
    required this.sharesCount,
    required this.onCommentTap,
    required this.onBookmarkTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.height * 0.025,
      children: [
        IconButtonComponent(
          icon: AppIcons.COMMENTS,
          value: commentsCount,
          onTap: onCommentTap,
        ),
        IconButtonComponent(
          icon: AppIcons.FAVORITE,
          value: bookmarkedCount,
          onTap: onBookmarkTap,
        ),
        IconButtonComponent(
          icon: AppIcons.SHARE,
          value: sharesCount,
          onTap: onShareTap,
        ),
      ],
    );
  }
}

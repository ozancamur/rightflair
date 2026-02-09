import 'package:flutter/material.dart';

import '../../../feature/create_post/model/post.dart';
import '../../../feature/create_post/model/post_user.dart';
import '../../extensions/context.dart';
import 'post_actions.dart';
import 'post_image.dart';
import 'post_shadow.dart';
import 'post_user_info.dart';

class PostComponent extends StatelessWidget {
  final PostModel post;
  final VoidCallback onComment;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final bool isDraft;
  final double? height;
  const PostComponent({
    super.key,
    required this.post,
    required this.onComment,
    required this.onSave,
    required this.onShare,
    this.isDraft = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? context.height,
      width: context.width,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(context.width * 0.06),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PostImageComponent(url: post.postImageUrl),
          const PostShadowComponent(),
          PostUserInfoComponent(user: post.user ?? PostUserModel()),
          isDraft
              ? SizedBox.shrink()
              : PostActionsComponent(
                  comment: post.commentsCount ?? 0,
                  saved: post.savesCount ?? 0,
                  shared: post.sharesCount ?? 0,
                  postId: post.id ?? "",
                  onComment: onComment,
                  onSave: onSave,
                  onShare: onShare,
                  isSaved: post.isSaved ?? false,
                ),
        ],
      ),
    );
  }
}

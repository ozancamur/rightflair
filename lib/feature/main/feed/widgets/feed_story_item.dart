import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/feature/main/feed/models/user_with_stories.dart';

import '../../../../core/constants/color/color.dart';
import '../../../../core/constants/route.dart';
import '../../../../core/extensions/context.dart';

class FeedStoryItemWidget extends StatelessWidget {
  final UserWithStoriesModel story;
  final List<UserWithStoriesModel> stories;
  final int index;

  const FeedStoryItemWidget({
    super.key,
    required this.story,
    required this.stories,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnseenStories = story.hasUnseenStories ?? false;

    return GestureDetector(
      onTap: () {
        context.push(
          RouteConstants.STORY_VIEWER,
          extra: {'allStories': stories, 'initialUserIndex': index},
        );
      },
      child: Container(
        height: context.height * .055,
        width: context.height * .055,
        margin: EdgeInsets.symmetric(horizontal: context.width * .01),
        padding: EdgeInsets.all(2),
        decoration: hasUnseenStories
            ? BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.YELLOW, AppColors.ORANGE],
                ),
              )
            : BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.tertiary, width: 1),
              ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.primary,
          ),
          child:
              (story.user?.profilePhotoUrl == null ||
                  story.user?.profilePhotoUrl == "")
              ? Icon(Icons.person, color: context.colors.secondary)
              : ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: story.user!.profilePhotoUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}

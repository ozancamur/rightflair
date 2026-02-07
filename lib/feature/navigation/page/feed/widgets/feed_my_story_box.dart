import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/create_story/page/create_story_dialog.dart';
import 'package:rightflair/feature/navigation/page/feed/models/my_story.dart';
import 'package:rightflair/feature/navigation/page/feed/models/story.dart';
import 'package:rightflair/feature/navigation/page/feed/models/user_with_stories.dart';

import '../../../../../core/extensions/context.dart';

class FeedMyStoryBoxWidget extends StatelessWidget {
  final MyStoryModel? myStory;
  const FeedMyStoryBoxWidget({super.key, this.myStory});

  void _openMyStories(BuildContext context) {
    if (myStory?.stories == null || myStory!.stories!.isEmpty) {
      dialogCreateStory(context, uid: myStory?.user?.id ?? "");
      return;
    }

    final userWithStories = UserWithStoriesModel(
      user: myStory!.user,
      hasUnseenStories: false,
      storiesCount: myStory!.stories?.length ?? 0,
      stories: myStory!.stories?.map((myStoryItem) {
        return StoryModel(
          id: myStoryItem.id,
          mediaUrl: myStoryItem.mediaUrl,
          mediaType: myStoryItem.mediaType,
          duration: myStoryItem.duration,
          viewCount: myStoryItem.viewCount,
          createdAt: myStoryItem.createdAt,
          expiresAt: myStoryItem.expiresAt,
          isViewed: true,
        );
      }).toList(),
    );

    context.push(
      RouteConstants.STORY_VIEWER,
      extra: {
        'allStories': [userWithStories],
        'initialUserIndex': 0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasStories = myStory?.stories != null && myStory!.stories!.isNotEmpty;

    return GestureDetector(
      onTap: () => _openMyStories(context),
      child: SizedBox(
        height: context.height * .055,
        width: context.height * .055,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: context.height * .055,
                width: context.height * .055,
                decoration: hasStories
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
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.primary,
                  ),
                  child: myStory?.user?.profilePhotoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: myStory!.user!.profilePhotoUrl!,
                            fit: BoxFit.cover,
                            memCacheWidth: 100,
                            memCacheHeight: 100,
                            maxWidthDiskCache: 100,
                            maxHeightDiskCache: 100,
                            placeholder: (context, url) =>
                                Icon(Icons.person, color: Colors.grey),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.person, color: Colors.grey),
                          ),
                        )
                      : Icon(Icons.person, color: Colors.grey),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () =>
                    dialogCreateStory(context, uid: myStory?.user?.id ?? ""),
                child: Container(
                  height: context.height * .02,
                  width: context.height * .02,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.primary,
                    border: Border.all(
                      color: context.colors.secondary,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: context.height * .0175,
                    color: context.colors.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

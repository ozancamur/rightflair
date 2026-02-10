import 'package:flutter/material.dart';
import 'package:rightflair/feature/main/feed/widgets/feed_story_item.dart';

import '../../../../core/extensions/context.dart';
import '../models/user_with_stories.dart';

class FeedStoriesListWidget extends StatelessWidget {
  final List<UserWithStoriesModel>? stories;
  const FeedStoriesListWidget({super.key, this.stories});

  @override
  Widget build(BuildContext context) {
    if (stories == null || stories!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: SizedBox(
        height: context.height * .055,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: context.width * .02),
          shrinkWrap: true,
          itemCount: stories!.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          itemBuilder: (context, index) {
            final story = stories![index];
            return FeedStoryItemWidget(
              story: story,
              stories: stories!,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

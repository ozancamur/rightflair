import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context.dart';
import '../bloc/feed_bloc.dart';
import 'feed_my_story_box.dart';
import 'feed_stories_list.dart';

class FeedAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const FeedAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.secondary,
      foregroundColor: context.colors.primary,
      elevation: 0,
      leadingWidth: 0,
      title: _title(context),
    );
  }

  BlocBuilder<FeedBloc, FeedState> _title(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (!state.isLoading) ...[
              FeedMyStoryBoxWidget(myStory: state.myStory),
              FeedStoriesListWidget(stories: state.stories),
            ],
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

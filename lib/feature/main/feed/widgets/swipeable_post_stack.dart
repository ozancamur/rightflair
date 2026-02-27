import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../../core/components/profile/profile_non_post.dart';
import '../bloc/feed_bloc.dart';
import '../../../../core/constants/enums/swipe_direction.dart';
import 'feed_post_swipe.dart';
import 'suggested_users_list.dart';

class SwipeablePostStack extends StatefulWidget {
  final int tabIndex;

  const SwipeablePostStack({super.key, required this.tabIndex});

  @override
  State<SwipeablePostStack> createState() => _SwipeablePostStackState();
}

class _SwipeablePostStackState extends State<SwipeablePostStack> {
  @override
  void initState() {
    super.initState();
  }

  void _onSwipeComplete(String postId, SwipeDirection direction) {
    final bloc = context.read<FeedBloc>();

    if (direction == SwipeDirection.right) {
      bloc.add(SwipeRightEvent(postId: postId));
    } else if (direction == SwipeDirection.left) {
      bloc.add(SwipeLeftEvent(postId: postId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      buildWhen: (prev, curr) {
        // Only rebuild when relevant tab data changes
        return prev.postsForTab(widget.tabIndex) !=
                curr.postsForTab(widget.tabIndex) ||
            prev.isLoadingForTab(widget.tabIndex) !=
                curr.isLoadingForTab(widget.tabIndex) ||
            prev.isLoadingMoreForTab(widget.tabIndex) !=
                curr.isLoadingMoreForTab(widget.tabIndex) ||
            (widget.tabIndex == 2 &&
                (prev.suggestedUsers != curr.suggestedUsers ||
                    prev.friendsFeedState != curr.friendsFeedState));
      },
      builder: (context, state) {
        final isLoading = state.isLoadingForTab(widget.tabIndex);
        final posts = state.postsForTab(widget.tabIndex);
        final isLoadingMore = state.isLoadingMoreForTab(widget.tabIndex);

        if (isLoading) return const LoadingComponent();

        // Friends tab: show suggested users when no posts or feed ended
        if (widget.tabIndex == 2) {
          final feedState = state.friendsFeedState;
          final suggestedUsers = state.suggestedUsers ?? [];

          if ((feedState == 'no_friends' || (posts?.isEmpty ?? true)) &&
              suggestedUsers.isNotEmpty) {
            return SuggestedUsersList(suggestedUsers: suggestedUsers);
          }
        }

        if (posts?.isEmpty ?? true) {
          if (!isLoadingMore) return const ProfileNonPostComponent();
          return const LoadingComponent();
        }

        return Stack(
          children: [
            if (isLoadingMore) const Center(child: LoadingComponent()),
            ...List.generate(posts?.length ?? 0, (index) {
              final post = posts![posts.length - 1 - index];
              final isTop = index == posts.length - 1;

              return Positioned.fill(
                child: IgnorePointer(
                  ignoring: !isTop,
                  child: FeedPostItem(
                    post: post,
                    onSwipeComplete: isTop ? _onSwipeComplete : null,
                  ),
                ),
              );
            }),
            // Friends tab: show suggested users at bottom when feed ended
            if (widget.tabIndex == 2 &&
                state.friendsFeedState == 'feed_ended' &&
                (state.suggestedUsers?.isNotEmpty ?? false) &&
                (posts?.isEmpty ?? true))
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SuggestedUsersList(
                  suggestedUsers: state.suggestedUsers!,
                ),
              ),
          ],
        );
      },
    );
  }
}

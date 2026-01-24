import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../../create_post/model/post.dart';
import '../bloc/feed_bloc.dart';
import '../models/swipe_direction.dart';
import 'feed_post_item.dart';

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
    //context.read<FeedBloc>().add(LoadFeedEvent(widget.tabIndex));
  }

  void _onSwipeComplete(String postId, SwipeDirection direction) {
    final bloc = context.read<FeedBloc>();

    if (direction == SwipeDirection.right) {
      bloc.add(SwipeRightEvent(tabIndex: widget.tabIndex, postId: postId));
    } else if (direction == SwipeDirection.left) {
      bloc.add(SwipeLeftEvent(tabIndex: widget.tabIndex, postId: postId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state.isLoading) const LoadingComponent();
        if (state.posts?.length == 0) SizedBox.shrink();

        final displayPosts = state.posts!.take(3).toList();

        return Stack(
          children: List.generate(displayPosts.length, (index) {
            final post = displayPosts[displayPosts.length - 1 - index];
            final isTop = index == displayPosts.length - 1;

            return _buildCard(
              post: post,
              index: index,
              totalCards: displayPosts.length,
              isTop: isTop,
            );
          }),
        );
      },
    );
  }

  Widget _buildCard({
    required PostModel post,
    required int index,
    required int totalCards,
    required bool isTop,
  }) {
    // Tüm kartlar aynı boyutta
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isTop,
        child: FeedPostItem(
          post: post,
          onSwipeComplete: isTop ? _onSwipeComplete : null,
        ),
      ),
    );
  }
}

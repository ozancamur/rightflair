import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../../../core/components/profile/profile_non_post.dart';
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

    context.read<FeedBloc>().add(
      LoadPostInitializeEvent(currentTabIndex: widget.tabIndex),
    );
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
      builder: (context, state) {
        if (state.isLoading) return const LoadingComponent();
        if (state.posts?.length == 0) return const ProfileNonPostComponent();

        return Stack(
          children: List.generate(state.posts?.length ?? 0, (index) {
            final post = state.posts![state.posts!.length - 1 - index];
            final isTop = index == state.posts!.length - 1;

            return _post(
              post: post,
              index: index,
              totalCards: state.posts!.length,
              isTop: isTop,
            );
          }),
        );
      },
    );
  }

  Widget _post({
    required PostModel post,
    required int index,
    required int totalCards,
    required bool isTop,
  }) {
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

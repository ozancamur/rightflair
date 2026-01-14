import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';
import '../bloc/feed_bloc.dart';
import '../models/feed_post_model.dart';
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
    // Tab açıldığında postları yükle
    context.read<FeedBloc>().add(LoadFeedEvent(widget.tabIndex));
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
        if (state.status == FeedStatus.loading &&
            !state.hasPostsForTab(widget.tabIndex)) {
          return const LoadingComponent();
        }

        if (state.status == FeedStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: context.width * 0.12,
                  color: AppDarkColors.RED,
                ),
                SizedBox(height: context.height * 0.02),
                TextComponent(
                  text: state.errorMessage ?? AppStrings.ERROR_OCCURRED,
                  size: FontSizeConstants.LARGE,
                  color: AppDarkColors.PRIMARY,
                  align: TextAlign.center,
                ),
                SizedBox(height: context.height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    context.read<FeedBloc>().add(
                      LoadFeedEvent(widget.tabIndex),
                    );
                  },
                  child: TextComponent(
                    text: AppStrings.ERROR_TRY_AGAIN,
                    size: FontSizeConstants.LARGE,
                    color: AppDarkColors.SECONDARY,
                  ),
                ),
              ],
            ),
          );
        }

        final posts = state.getPostsForTab(widget.tabIndex);

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: context.width * 0.16,
                  color: AppDarkColors.GREY,
                ),
                SizedBox(height: context.height * 0.02),
                TextComponent(
                  text: AppStrings.ERROR_NO_POSTS,
                  size: FontSizeConstants.LARGE,
                  color: AppDarkColors.GREY,
                ),
                SizedBox(height: context.height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    context.read<FeedBloc>().add(
                      LoadFeedEvent(widget.tabIndex),
                    );
                  },
                  child: TextComponent(
                    text: AppStrings.ERROR_REFRESH,
                    size: FontSizeConstants.LARGE,
                    color: AppDarkColors.SECONDARY,
                  ),
                ),
              ],
            ),
          );
        }

        // En fazla 3 kart göster (stack effect için)
        final displayPosts = posts.take(3).toList();

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
    required FeedPostModel post,
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

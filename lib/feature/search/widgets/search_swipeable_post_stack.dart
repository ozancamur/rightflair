import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';

import '../../../../core/components/profile/profile_non_post.dart';
import '../../../../core/constants/enums/swipe_direction.dart';
import '../cubit/search_cubit.dart';
import 'search_post_swipe_item.dart';

class SearchSwipeablePostStack extends StatelessWidget {
  const SearchSwipeablePostStack({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.isLoading && state.searchResults.isEmpty) {
          return const LoadingComponent();
        }

        if (state.searchResults.isEmpty) {
          return const ProfileNonPostComponent();
        }

        return Stack(
          children: [
            if (state.isLoading && state.searchResults.isNotEmpty)
              const Center(child: LoadingComponent()),
            ...List.generate(state.searchResults.length, (index) {
              final post =
                  state.searchResults[state.searchResults.length - 1 - index];
              final isTop = index == state.searchResults.length - 1;

              return Positioned.fill(
                child: IgnorePointer(
                  ignoring: !isTop,
                  child: SearchPostSwipeItem(
                    post: post,
                    onSwipeComplete: isTop
                        ? (postId, direction) {
                            final cubit = context.read<SearchCubit>();
                            if (direction == SwipeDirection.right) {
                              cubit.swipeRight(postId);
                            } else if (direction == SwipeDirection.left) {
                              cubit.swipeLeft(postId);
                            }
                          }
                        : null,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/components/profile/profile_header.dart';
import 'package:rightflair/feature/user/repository/user_repository_impl.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/profile/profile_post_grid.dart';
import '../../../core/components/profile/profile_tab_item.dart';
import '../../../core/constants/enums/follow_list_type.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
import '../widgets/user_appbar.dart';

class UserPage extends StatelessWidget {
  final String userId;
  const UserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserCubit(UserRepositoryImpl())..init(context, userId: userId),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return BaseScaffold(
            canPop: true,
            appBar: UserAppbarWidget(
              userId: userId,
              fullname: state.user.fullName ?? '',
              isFollowing: state.isFollowing,
              isNotificationEnabled: state.isNotificationEnabled,
            ),
            body: RefreshIndicator(
              onRefresh: () =>
                  context.read<UserCubit>().refresh(userId: userId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.05,
                  ),
                  child: Column(
                    spacing: context.height * 0.025,
                    children: [
                      ProfileHeaderComponent(
                        user: state.user,
                        tags: state.tags?.styleTags ?? [],
                        isFollowing: state.isFollowing,
                        userStories: state.userStories,
                        onStoryTap: () async {
                          final stories = state.userStories;
                          if (stories != null &&
                              (stories.stories?.isNotEmpty ?? false)) {
                            await context.push(
                              RouteConstants.STORY_VIEWER,
                              extra: {
                                'isMyStory': false,
                                'allStories': [stories],
                                'initialUserIndex': 0,
                                'onStoryViewed':
                                    (String storyId, String userId) {
                                      if (context.mounted) {
                                        context
                                            .read<UserCubit>()
                                            .markStoryAsViewed(
                                              storyId: storyId,
                                            );
                                      }
                                    },
                              },
                            );
                            if (context.mounted) {
                              context.read<UserCubit>().refreshStories(
                                userId: userId,
                              );
                            }
                          }
                        },
                        onFollowTap: () {
                          context.read<UserCubit>().followUser(userId: userId);
                        },
                        onMessageTap: () {
                          //todo
                        },
                        onFollowersTap: () => context.push(
                          RouteConstants.FOLLOW,
                          extra: {
                            "listType": FollowListType.followers,
                            'username': state.user.username ?? '',
                            'userId': userId,
                          },
                        ),
                        onFollowingTap: () => context.push(
                          RouteConstants.FOLLOW,
                          extra: {
                            "listType": FollowListType.following,
                            'username': state.user.username ?? '',
                            'userId': userId,
                          },
                        ),
                      ),
                      ProfileTabItemComponent(text: AppStrings.PROFILE_PHOTOS),
                      ProfilePostGridComponent(
                        posts: state.posts,
                        isLoading: state.isPostsLoading,
                        isDraft: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

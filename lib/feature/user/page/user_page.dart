import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../follow/page/dialog_follow_list.dart';
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
            appBar: UserAppbarWidget(
              userId: userId,
              fullname: state.user.fullName ?? '',
              isFollowing: state.isFollowing,
              isNotificationEnabled: state.isNotificationEnabled,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                child: Column(
                  spacing: context.height * 0.025,
                  children: [
                    ProfileHeaderComponent(
                      user: state.user,
                      tags: state.tags?.styleTags ?? [],
                      isFollowing: state.isFollowing,
                      onFollowTap: () {
                        context.read<UserCubit>().followUser(userId: userId);
                      },
                      onMessageTap: () {},
                      onFollowersTap: () {
                        dialogFollowList(
                          context,
                          listType: FollowListType.followers,
                          userId: userId,
                        );
                      },
                      onFollowingTap: () {
                        dialogFollowList(
                          context,
                          listType: FollowListType.following,
                          userId: userId,
                        );
                      },
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
          );
        },
      ),
    );
  }
}

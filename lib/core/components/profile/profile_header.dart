import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/components/profile/profile_action_buttons.dart';

import '../../../feature/authentication/model/user.dart';
import '../../../feature/main/feed/models/user_with_stories.dart';
import '../../../feature/main/profile/cubit/profile_cubit.dart';
import '../../constants/enums/follow_list_type.dart';
import '../../constants/route.dart';
import 'header/profile_header_bio.dart';
import 'header/profile_header_image.dart';
import 'header/profile_header_stats.dart';
import 'header/profile_header_tags.dart';
import 'header/profile_header_username.dart';

class ProfileHeaderComponent extends StatelessWidget {
  final UserModel user;
  final List<String> tags;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onEditPhoto;
  final bool isCanEdit;
  final bool isFollowing;
  final UserWithStoriesModel? userStories;
  final VoidCallback? onStoryTap;

  const ProfileHeaderComponent({
    super.key,
    required this.tags,
    this.onFollowTap,
    this.onMessageTap,
    this.onEditPhoto,
    this.isCanEdit = false,
    required this.user,
    this.isFollowing = false,
    this.userStories,
    this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeaderImageComponent(
          isCanEdit: isCanEdit,
          user: user,
          tags: tags,
          onRefresh: () => context.read<ProfileCubit>().refresh(),
          onEditPhoto: onEditPhoto,
          userStories: userStories,
          onStoryTap: onStoryTap,
        ),
        SizedBox(height: context.height * 0.005),
        ProfileHeaderUsernameComponent(
          name: user.fullName,
          username: user.username ?? "@rightflair_user",
        ),
        SizedBox(height: context.height * 0.005),
        _follow(context),
        if (onFollowTap != null && onMessageTap != null) ...[
          SizedBox(height: context.height * (isCanEdit ? 0.01 : 0.005)),
          ProfileActionButtonsComponent(
            onFollowTap: onFollowTap!,
            onMessageTap: onMessageTap!,
            isFollowing: isFollowing,
          ),
        ],
        ProfileHeaderBioComponent(text: user.bio),
        ProfileHeaderTagsComponent(tags: tags),
      ],
    );
  }

  ProfileHeaderStatsComponent _follow(BuildContext context) {
    return ProfileHeaderStatsComponent(
      followerCount: user.followersCount ?? 0,
      followingCount: user.followingCount ?? 0,
      onFollowersTap: () => context.push(
        RouteConstants.FOLLOW,
        extra: {
          "listType": FollowListType.followers,
          'username': user.username ?? '',
          'userId': user.id ?? '',
          'followers': user.followersCount ?? 0,
          'following': user.followingCount ?? 0,
        },
      ),
      onFollowingTap: () => context.push(
        RouteConstants.FOLLOW,
        extra: {
          "listType": FollowListType.following,
          'username': user.username ?? '',
          'userId': user.id ?? '',
          'followers': user.followersCount ?? 0,
          'following': user.followingCount ?? 0,
        },
      ),
    );
  }
}

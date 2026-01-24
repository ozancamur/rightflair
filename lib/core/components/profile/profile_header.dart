import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/components/profile/profile_action_buttons.dart';

import '../../../feature/authentication/model/user.dart';
import '../../../feature/navigation/page/profile/cubit/profile_cubit.dart';
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

  const ProfileHeaderComponent({
    super.key,
    required this.tags,
    this.onFollowTap,
    this.onMessageTap,
    this.onEditPhoto,
    this.isCanEdit = false,
    required this.user,
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
          onPhotoChange: onEditPhoto,
        ),
        ProfileHeaderUsernameComponent(
          name: user.fullName,
          username: user.username ?? "@rightflair_user",
        ),
        SizedBox(height: context.height * 0.015),
        ProfileHeaderStatsComponent(
          followerCount: user.followersCount ?? 0,
          followingCount: user.followingCount ?? 0,
        ),
        SizedBox(height: context.height * 0.01),
        (onFollowTap == null && onMessageTap == null)
            ? SizedBox.shrink()
            : ProfileActionButtonsComponent(
                onFollowTap: onFollowTap!,
                onMessageTap: onMessageTap!,
              ),
        ProfileHeaderBioComponent(text: user.bio ?? ""),
        SizedBox(height: context.height * 0.01),
        ProfileHeaderTagsComponent(tags: tags),
      ],
    );
  }
}

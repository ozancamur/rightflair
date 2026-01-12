import 'package:flutter/material.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/profile/widgets/profile_action_buttons_widget.dart';

import 'header/profile_header_bio.dart';
import 'header/profile_header_image.dart';
import 'header/profile_header_stats.dart';
import 'header/profile_header_tags.dart';
import 'header/profile_header_username.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String profileImage;
  final String name;
  final String username;
  final int followerCount;
  final int followingCount;
  final String bio;
  final List<String> tags;
  final VoidCallback onFollowTap;
  final VoidCallback onMessageTap;

  const ProfileHeaderWidget({
    super.key,
    required this.profileImage,
    required this.name,
    required this.username,
    required this.followerCount,
    required this.followingCount,
    required this.bio,
    required this.tags,
    required this.onFollowTap,
    required this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.height * 0.015,
      children: [
        ProfileHeaderImageWidget(url: profileImage),
        ProfileHeaderUsernameWidget(name: name, username: username),
        ProfileHeaderStatsWidget(
          followerCount: followerCount,
          followingCount: followingCount,
        ),
        ProfileActionButtonsWidget(
          onFollowTap: onFollowTap,
          onMessageTap: onMessageTap,
        ),
        ProfileHeaderBioWidget(text: bio),
        ProfileHeaderTagsWidget(tags: tags),
      ],
    );
  }
}

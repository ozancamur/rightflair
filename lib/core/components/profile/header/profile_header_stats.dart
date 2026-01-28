import 'package:flutter/material.dart';

import '../../../../../../core/constants/string.dart';
import '../../../../../../core/extensions/context.dart';
import '../profile_stats.dart';

class ProfileHeaderStatsComponent extends StatelessWidget {
  final int followerCount;
  final int followingCount;
  const ProfileHeaderStatsComponent({
    super.key,
    required this.followerCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: context.width * 0.1,
      children: [
        ProfileStatsComponent(
          count: followerCount,
          label: AppStrings.PROFILE_FOLLOWER,
        ),
        ProfileStatsComponent(
          count: followingCount,
          label: AppStrings.PROFILE_FOLLOWING,
        ),
      ],
    );
  }
}

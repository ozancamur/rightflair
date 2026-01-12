import 'package:flutter/material.dart';

import '../../../../../../core/constants/string.dart';
import '../../../../../../core/extensions/context.dart';
import '../profile_stats_widget.dart';

class ProfileHeaderStatsWidget extends StatelessWidget {
  final int followerCount;
  final int followingCount;
  const ProfileHeaderStatsWidget({
    super.key,
    required this.followerCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: context.width * 0.15,
      children: [
        ProfileStatsWidget(
          count: followerCount,
          label: AppStrings.PROFILE_FOLLOWER,
        ),
        ProfileStatsWidget(
          count: followingCount,
          label: AppStrings.PROFILE_FOLLOWING,
        ),
      ],
    );
  }
}

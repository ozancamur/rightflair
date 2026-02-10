import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/helpers/date.dart';

import '../../../../../core/extensions/context.dart';
import '../../../../main/inbox/widgets/messages/message_avatar.dart';
import '../../model/new_follower.dart';
import 'follow_back_button.dart';
import 'follower_information.dart';

class FollowerItemWidget extends StatelessWidget {
  final NewFollowerModel follower;

  const FollowerItemWidget({super.key, required this.follower});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.03),
      decoration: BoxDecoration(
        color: context.colors.onSecondary,
        borderRadius: BorderRadius.circular(context.width * 0.03),
      ),
      child: Row(
        spacing: context.width * 0.03,
        children: [
          // Profile image
          MessageAvatarWidget(
            url: follower.profilePhotoUrl,
            id: follower.id ?? "",
          ),

          // Username and subtitle
          FollowerInformationWidget(
            username: follower.username ?? "rightflair_user",
            subtitle: AppStrings.INBOX_STARTED_FOLLOWING_YOU,
            timeAgo: DateHelper.timeAgo(follower.followedAt),
          ),

          // Follow back button
          FollowBackButtonWidget(
            isFollowing: follower.isFollowingBack ?? false,
          ),
        ],
      ),
    );
  }
}

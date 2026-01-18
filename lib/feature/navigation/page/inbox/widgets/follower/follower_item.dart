import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context.dart';
import 'follow_back_button.dart';
import 'follower_image.dart';
import 'follower_information.dart';

class FollowerItemWidget extends StatelessWidget {
  final String username;
  final String subtitle;
  final String timeAgo;
  final String profileImage;

  const FollowerItemWidget({
    super.key,
    required this.username,
    required this.subtitle,
    required this.timeAgo,
    required this.profileImage,
  });

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
          FollowerImageWidget(url: profileImage),

          // Username and subtitle
          FollowerInformationWidget(
            username: username,
            subtitle: subtitle,
            timeAgo: timeAgo,
          ),

          // Follow back button
          const FollowBackButtonWidget(),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/loading.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/icons.dart';
import '../../../core/extensions/context.dart';
import '../../main/inbox/model/notification_sender.dart';

class SuggestedUserCard extends StatelessWidget {
  final NotificationSenderModel user;
  final bool isFollowed;
  final VoidCallback onFollow;
  final VoidCallback onTap;

  const SuggestedUserCard({
    super.key,
    required this.user,
    this.isFollowed = false,
    required this.onFollow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.width * 0.02),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.04,
          vertical: context.height * 0.01,
        ),
        child: _buildUserInfo(context),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(context),
        SizedBox(width: context.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextComponent(
                text: user.fullName ?? '',
                tr: false,
                size: FontSizeConstants.NORMAL,
                weight: FontWeight.w700,
                color: context.colors.primary,
                maxLine: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.height * 0.002),
              TextComponent(
                text: '@${user.username ?? ''}',
                tr: false,
                size: FontSizeConstants.SMALL,
                weight: FontWeight.w400,
                color: context.colors.primaryContainer,
                maxLine: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildFollowButton(context),
      ],
    );
  }

  Widget _buildFollowButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isFollowed
            ? null
            : const LinearGradient(
                colors: [Colors.orange, Colors.yellow],
                begin: Alignment.center,
                end: Alignment.bottomRight,
              ),
        color: isFollowed ? Colors.grey.shade400 : null,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onFollow,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(context.width * 0.025),
            child: Icon(
              isFollowed ? Icons.person_remove : Icons.person_add,
              color: Colors.white,
              size: context.width * 0.055,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (user.profilePhotoUrl == null || user.profilePhotoUrl!.isEmpty) {
      return CircleAvatar(
        radius: context.height * 0.032,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: context.height * 0.035,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: user.profilePhotoUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: context.height * 0.032,
        backgroundImage: imageProvider,
        backgroundColor: Colors.grey.shade200,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: context.height * 0.032,
        backgroundColor: Colors.grey.shade200,
        child: const LoadingComponent(),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: context.height * 0.032,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: context.height * 0.035,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      ),
    );
  }
}

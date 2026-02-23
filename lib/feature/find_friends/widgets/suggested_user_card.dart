import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/loading.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../../main/inbox/model/notification_sender.dart';

class SuggestedUserCard extends StatelessWidget {
  final NotificationSenderModel user;
  final VoidCallback onRemove;
  final VoidCallback onFollow;
  final VoidCallback onTap;

  const SuggestedUserCard({
    super.key,
    required this.user,
    required this.onRemove,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context),
            SizedBox(height: context.height * 0.012),
            _buildActionButtons(context),
          ],
        ),
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
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_horiz,
            color: context.colors.primaryContainer,
            size: context.width * 0.05,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onRemove,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: context.colors.primaryContainer.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.width * 0.02),
              ),
              padding: EdgeInsets.symmetric(vertical: context.height * 0.012),
            ),
            child: TextComponent(
              text: AppStrings.FIND_FRIENDS_REMOVE.tr(),
              tr: false,
              size: FontSizeConstants.SMALL,
              weight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
        ),
        SizedBox(width: context.width * 0.03),
        Expanded(
          child: ElevatedButton(
            onPressed: onFollow,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.width * 0.02),
              ),
              padding: EdgeInsets.symmetric(vertical: context.height * 0.012),
              elevation: 0,
            ),
            child: TextComponent(
              text: AppStrings.FIND_FRIENDS_FOLLOW_BACK.tr(),
              tr: false,
              size: FontSizeConstants.SMALL,
              weight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
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

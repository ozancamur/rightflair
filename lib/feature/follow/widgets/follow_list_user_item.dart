import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/loading.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/icons.dart';
import '../../../core/extensions/context.dart';
import '../../authentication/model/user.dart';

class FollowListUserItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  const FollowListUserItem({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.width * 0.02),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.012),
        child: Row(
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
                    weight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (user.profilePhotoUrl == null || user.profilePhotoUrl!.isEmpty) {
      return CircleAvatar(
        radius: context.height * 0.028,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: context.height * 0.03,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: user.profilePhotoUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: context.height * 0.028,
        backgroundImage: imageProvider,
        backgroundColor: Colors.grey.shade200,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: context.height * 0.028,
        backgroundColor: Colors.grey.shade200,
        child: const LoadingComponent(),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: context.height * 0.028,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: context.height * 0.03,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      ),
    );
  }
}

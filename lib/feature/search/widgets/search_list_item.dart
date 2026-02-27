import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/icons.dart';
import '../../../core/extensions/context.dart';
import '../../share/model/share.dart';

class SearchListItemWidget extends StatelessWidget {
  final SearchUserModel user;
  const SearchListItemWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.USER, extra: user.id),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: _avatar(user.profilePhotoUrl),
        title: TextComponent(
          text: user.fullName ?? '',
          tr: false,
          size: FontSizeConstants.NORMAL,
          color: context.colors.primary,
          weight: FontWeight.w600,
        ),
        subtitle: TextComponent(
          text: '@${user.username ?? ''}',
          tr: false,
          size: FontSizeConstants.SMALL,
          color: context.colors.onPrimary.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _avatar(String? url) {
    const double radius = 22;
    if (url == null || url.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: radius * 1.2,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (_, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
        backgroundColor: Colors.grey.shade200,
      ),
      placeholder: (_, __) =>
          CircleAvatar(radius: radius, backgroundColor: Colors.grey.shade200),
      errorWidget: (_, __, ___) => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: radius * 1.2,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      ),
    );
  }
}

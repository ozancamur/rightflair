import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/icons.dart';

class ShareUserAvatarWidget extends StatelessWidget {
  final String? url;
  const ShareUserAvatarWidget({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    const double radius = 20;
    if (url == null || url == "") {
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
      imageUrl: url!,
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/icons.dart';
import '../../../extensions/context.dart';
import '../../loading.dart';

class ProfilePhotoComponent extends StatelessWidget {
  final String? url;
  const ProfilePhotoComponent({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _buildPlaceholder(context);
    }

    return CachedNetworkImage(
      imageUrl: url!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: context.height * .06,
        backgroundImage: imageProvider,
        backgroundColor: Colors.grey.shade200,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: context.height * .06,
        backgroundColor: Colors.grey.shade200,
        child: const LoadingComponent(),
      ),
      errorWidget: (context, url, error) => _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade200,
      radius: context.height * .06,
      child: SvgPicture.asset(
        AppIcons.NON_PROFILE_PHOTO,
        height: context.height * .065,
        colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/icons.dart';

import '../../../../core/constants/route.dart';
import '../../../../core/extensions/context.dart';

class UserImageWidget extends StatelessWidget {
  final String? id;
  final String? url;
  const UserImageWidget({super.key, this.id, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => (id == null || id == "")
          ? null
          : context.push(RouteConstants.USER, extra: id),
      child: SizedBox(
        height: context.height * .06,
        width: context.height * .06,
        child: ClipOval(
          child: (url == null || url == "")
              ? SvgPicture.asset(AppIcons.PROFILE)
              : CachedNetworkImage(imageUrl: url ?? "", fit: BoxFit.cover),
        ),
      ),
    );
  }
}

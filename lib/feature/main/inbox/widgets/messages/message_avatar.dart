import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../core/constants/route.dart';

class MessageAvatarWidget extends StatelessWidget {
  final String? id;
  final String? url;
  const MessageAvatarWidget({super.key, this.id, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => (id == null || id == "")
          ? null
          : context.push(RouteConstants.USER, extra: id),
      child: Container(
        width: context.width * 0.13,
        height: context.width * 0.13,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        clipBehavior: Clip.antiAlias,
        child: url == null || url == ""
            ? _null(context)
            : CachedNetworkImage(
                imageUrl: url ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: context.colors.onTertiary),
                errorWidget: (context, url, error) => _null(context),
              ),
      ),
    );
  }

  Container _null(BuildContext context) {
    return Container(
      color: context.colors.tertiary,
      padding: EdgeInsets.all(context.width * 0.03),
      child: SvgPicture.asset(
        AppIcons.PROFILE,
        color: context.colors.onPrimary,
        height: context.height * 0.02,
      ),
    );
  }
}

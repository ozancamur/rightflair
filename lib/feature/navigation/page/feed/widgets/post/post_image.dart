import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';

import '../../../../../../core/extensions/context.dart';

class PostImageWidget extends StatelessWidget {
  final String? url;
  const PostImageWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.width * 0.06),
        child: CachedNetworkImage(
          imageUrl: url ?? "",
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            height: context.height,
            width: context.width,
            color: context.colors.onSecondaryFixed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: context.height * .01,
              children: [
                SvgPicture.asset(
                  AppIcons.NON_POST,
                  height: context.height * .04,
                  color: context.colors.secondary,
                ),
                TextComponent(
                  text: "Image failed.",
                  size: FontSizeConstants.X_LARGE,
                  color: context.colors.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

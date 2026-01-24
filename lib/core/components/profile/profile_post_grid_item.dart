import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../../core/components/text.dart';
import '../../../feature/create_post/model/post.dart';
import '../../constants/font/font_size.dart';
import '../../../../../core/extensions/context.dart';

class ProfilePostGridItemComponent extends StatelessWidget {
  final PostModel post;
  const ProfilePostGridItemComponent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(RouteConstants.POST_DETAIL),
      borderRadius: BorderRadius.circular(context.width * 0.03),
      child: Stack(
        children: [_image(context), _shadow(context), _view(context)],
      ),
    );
  }

  Container _image(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.width * 0.03),
        color: Colors.transparent,
        image: DecorationImage(
          image: NetworkImage(post.postImageUrl ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _shadow(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.width * 0.03),
        color: Colors.black.withOpacity(.3),
      ),
    );
  }

  Widget _view(BuildContext context) {
    return Positioned(
      bottom: context.height * 0.015,
      left: context.width * 0.0225,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.02,
          vertical: context.height * 0.003,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(context.width * 0.03),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: context.width * 0.01,
          children: [
            SvgPicture.asset(
              AppIcons.POST_VIEWED,
              color: Colors.white,
              height: context.width * 0.05,
            ),
            TextComponent(
              text: '${post.viewCount ?? 0}',
              size: FontSizeConstants.XX_SMALL,
              weight: FontWeight.w600,
              color: Colors.white,
              tr: false,
            ),
          ],
        ),
      ),
    );
  }
}

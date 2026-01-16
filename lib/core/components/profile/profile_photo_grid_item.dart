import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/extensions/context.dart';
import '../../../feature/navigation/page/profile/model/photo.dart';

class ProfilePhotoGridItemWidget extends StatelessWidget {
  final PhotoModel photo;
  const ProfilePhotoGridItemWidget({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(RouteConstants.POST_DETAIL),
      borderRadius: BorderRadius.circular(context.width * 0.03),
      child: Stack(children: [_image(context), _shadow(), _view(context)]),
    );
  }

  Container _image(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.width * 0.03),
        color: Colors.red,
        image: DecorationImage(
          image: NetworkImage(photo.url ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _shadow() {
    return Container(
      decoration: BoxDecoration(color: AppDarkColors.SECONDARY.withOpacity(.4)),
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
          borderRadius: BorderRadius.circular(context.width * 0.02),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: context.width * 0.01,
          children: [
            SvgPicture.asset(
              AppIcons.POST_VIEWED,
              color: AppDarkColors.PRIMARY,
              height: context.width * 0.05,
            ),
            TextComponent(
              text: '${photo.viewed}',
              size: FontSizeConstants.XX_SMALL,
              weight: FontWeight.w600,
              color: AppDarkColors.PRIMARY,
              tr: false,
            ),
          ],
        ),
      ),
    );
  }
}

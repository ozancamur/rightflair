import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/constants/icons.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/extensions/context.dart';

class ProfilePhotoGridItemWidget extends StatelessWidget {
  final String photo;
  const ProfilePhotoGridItemWidget({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_image(context), _shadow(), _view(context)]);
  }

  Container _image(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.width * 0.03),
        color: Colors.red,
        image: DecorationImage(image: NetworkImage(photo), fit: BoxFit.cover),
      ),
    );
  }

  Container _shadow() {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(.25)),
    );
  }

  Widget _view(BuildContext context) {
    return Positioned(
      bottom: context.height * 0.01,
      right: context.width * 0.02,
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
          children: [
            SvgPicture.asset(
              AppIcons.POST_VIEWED,
              color: AppDarkColors.PRIMARY,
              height: context.width * 0.05,
            ),
            SizedBox(width: context.width * 0.01),
            TextComponent(
              text: '1,247',
              size: FontSizeConstants.XXX_SMALL,
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

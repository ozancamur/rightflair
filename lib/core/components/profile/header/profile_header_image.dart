import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../../../core/extensions/context.dart';

class ProfileHeaderImageWidget extends StatelessWidget {
  final String url;
  final bool isCanEdit;
  const ProfileHeaderImageWidget({
    super.key,
    required this.url,
    required this.isCanEdit,
  });

  @override
  Widget build(BuildContext context) {
    return isCanEdit ? _profile(context) : _photo(context);
  }

  SizedBox _profile(BuildContext context) {
    return SizedBox(
      height: context.height * 0.15,
      width: context.width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [_photo(context), _change(context), _edit(context)],
      ),
    );
  }

  Positioned _change(BuildContext context) {
    return Positioned(
      top: context.height * .085,
      right: context.width * .31,
      child: InkWell(
        onTap: () {},
        customBorder: CircleBorder(),
        child: Container(
          height: context.height * .035,
          width: context.height * .035,
          padding: EdgeInsets.all(context.height * .006),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppDarkColors.ORANGE,
            border: Border.all(width: 2, color: AppDarkColors.SECONDARY),
          ),
          child: SvgPicture.asset(AppIcons.ADD),
        ),
      ),
    );
  }

  Positioned _edit(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: context.width * .175,
      child: InkWell(
        onTap: () => context.push(RouteConstants.EDIT_PROFILE),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: context.height * .03,
          width: context.width * .15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppDarkColors.WHITE08,
            border: Border.all(width: .5, color: AppDarkColors.WHITE16),
          ),
          child: Center(
            child: TextComponent(
              text: "Edit",
              size: FontSizeConstants.X_SMALL,
              color: AppDarkColors.PRIMARY,
            ),
          ),
        ),
      ),
    );
  }

  Container _photo(BuildContext context) {
    return Container(
      height: context.height * 0.12,
      width: context.height * 0.12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

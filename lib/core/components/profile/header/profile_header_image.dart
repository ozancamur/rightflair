import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../../../core/extensions/context.dart';
import '../../../../feature/authentication/model/user.dart';
import 'profile_photo.dart';

class ProfileHeaderImageWidget extends StatelessWidget {
  final bool isCanEdit;
  final UserModel user;
  const ProfileHeaderImageWidget({
    super.key,
    required this.isCanEdit,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return isCanEdit ? _profile(context) : ProfilePhotoComponent(url: user.profilePhotoUrl);
  }

  SizedBox _profile(BuildContext context) {
    return SizedBox(
      height: context.height * 0.15,
      width: context.width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [ProfilePhotoComponent(url: user.profilePhotoUrl), _change(context), _edit(context)],
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
            color: context.colors.scrim,
            border: Border.all(width: 2, color: context.colors.secondary),
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
        onTap: () => context.push(RouteConstants.EDIT_PROFILE, extra: user),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: context.height * .03,
          width: context.width * .15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: context.colors.onPrimaryContainer,
            border: Border.all(
              width: .5,
              color: context.colors.primaryFixedDim,
            ),
          ),
          child: Center(
            child: TextComponent(
              text: "Edit",
              size: FontSizeConstants.X_SMALL,
              color: context.colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

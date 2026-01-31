import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../feature/create_post/model/post_user.dart';
import '../text/text.dart';
import '../../constants/font/font_size.dart';
import '../../extensions/context.dart';

class PostUserInfoComponent extends StatelessWidget {
  final PostUserModel user;
  const PostUserInfoComponent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.USER, extra: user.id),
      child: Padding(
        padding: EdgeInsets.only(
          left: context.width * .04,
          bottom: context.width * .08,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: context.width * .03,
          children: [_photo(context), _fullname()],
        ),
      ),
    );
  }

  Container _photo(BuildContext context) {
    return Container(
      height: context.height * .045,
      width: context.height * .045,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.scrim, width: .5),
      ),
      child: (user.profilePhotoUrl == null || user.profilePhotoUrl == "")
          ? _null(context)
          : ClipOval(
              child: Image.network(
                user.profilePhotoUrl ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _null(context),
              ),
            ),
    );
  }

  Padding _null(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.width * 0.015),
      child: SvgPicture.asset(AppIcons.NON_PROFILE_PHOTO, color: Colors.black),
    );
  }

  TextComponent _fullname() {
    return TextComponent(
      text: user.fullName ?? "Rightflair User",
      size: FontSizeConstants.SMALL,
      color: Colors.white,
      weight: FontWeight.w600,
      tr: false,
    );
  }
}

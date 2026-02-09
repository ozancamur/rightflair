import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/create_post/model/post.dart';
import 'package:rightflair/feature/create_post/model/post_user.dart';

class SearchPostWidget extends StatelessWidget {
  final PostModel post;

  const SearchPostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          RouteConstants.POST_DETAIL,
          extra: {'post': post, 'isDraft': false},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(context.width * 0.04),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [_postImage(context), _shadow(context), _userInfo(context)],
        ),
      ),
    );
  }

  Widget _postImage(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.width * 0.04),
        child: (post.postImageUrl == null || post.postImageUrl == "")
            ? _nullImage(context)
            : CachedNetworkImage(
                imageUrl: post.postImageUrl ?? "",
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => _nullImage(context),
              ),
      ),
    );
  }

  Widget _nullImage(BuildContext context) {
    return Container(
      color: context.colors.onSecondaryFixed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: context.height * .01,
        children: [
          SvgPicture.asset(
            AppIcons.NON_POST,
            height: context.height * .03,
            color: context.colors.secondary,
          ),
          TextComponent(
            text: "Image failed.",
            size: FontSizeConstants.SMALL,
            color: context.colors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _shadow(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.width * 0.04),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
      ),
    );
  }

  Widget _userInfo(BuildContext context) {
    final user = post.user ?? PostUserModel();

    return Padding(
      padding: EdgeInsets.all(context.width * .03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: context.width * .02,
        children: [
          _userPhoto(context, user),
          Expanded(
            child: TextComponent(
              text: user.fullName ?? "Rightflair User",
              size: FontSizeConstants.X_SMALL,
              color: Colors.white,
              weight: FontWeight.w600,
              tr: false,
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userPhoto(BuildContext context, PostUserModel user) {
    return Container(
      height: context.height * .03,
      width: context.height * .03,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.scrim, width: .5),
      ),
      child: (user.profilePhotoUrl == null || user.profilePhotoUrl == "")
          ? _nullUserPhoto(context)
          : ClipOval(
              child: Image.network(
                user.profilePhotoUrl ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _nullUserPhoto(context),
              ),
            ),
    );
  }

  Widget _nullUserPhoto(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.width * 0.01),
      child: SvgPicture.asset(AppIcons.NON_PROFILE_PHOTO, color: Colors.black),
    );
  }
}

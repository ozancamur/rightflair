import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../../../core/extensions/context.dart';
import '../../../../feature/authentication/model/user.dart';
import '../../../../feature/main/feed/models/user_with_stories.dart';
import 'profile_photo.dart';
import 'story_ring.dart';

class ProfileHeaderImageComponent extends StatelessWidget {
  final bool isCanEdit;
  final UserModel user;
  final List<String> tags;
  final VoidCallback onRefresh;
  final VoidCallback? onPhotoChange;
  final UserWithStoriesModel? userStories;
  final VoidCallback? onStoryTap;

  const ProfileHeaderImageComponent({
    super.key,
    required this.isCanEdit,
    required this.user,
    required this.tags,
    required this.onRefresh,
    this.onPhotoChange,
    this.userStories,
    this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showEnlargedPhoto(context),
      child: isCanEdit
          ? _profile(context)
          : _storyRing(ProfilePhotoComponent(url: user.profilePhotoUrl)),
    );
  }

  void _showEnlargedPhoto(BuildContext context) {
    final url = user.profilePhotoUrl;
    if (url == null || url.isEmpty) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.95),
      pageBuilder: (context, _, __) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Tap anywhere to close
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
              // Close button
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
              // Centered circular photo
              Center(
                child: CachedNetworkImage(
                  imageUrl: url,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.42,
                    backgroundImage: imageProvider,
                    backgroundColor: Colors.grey.shade800,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.42,
                    backgroundColor: Colors.grey.shade800,
                    child: const CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _storyRing(Widget child) {
    final hasStories =
        userStories != null && (userStories!.stories?.isNotEmpty ?? false);
    final hasUnseen = isCanEdit
        ? false
        : (userStories?.hasUnseenStories ?? false);

    return StoryRingWidget(
      hasStories: hasStories,
      hasUnseen: hasUnseen,
      onTap: onStoryTap,
      child: child,
    );
  }

  SizedBox _profile(BuildContext context) {
    return SizedBox(
      height: context.height * 0.15,
      width: context.width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _storyRing(ProfilePhotoComponent(url: user.profilePhotoUrl)),
          _change(context),
          _edit(context),
        ],
      ),
    );
  }

  Positioned _change(BuildContext context) {
    return Positioned(
      top: context.height * .085,
      right: context.width * .31,
      child: InkWell(
        onTap: onPhotoChange,
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
        onTap: () async {
          final result = await context.push(
            RouteConstants.EDIT_PROFILE,
            extra: {'user': user, 'tags': tags},
          );
          if (result == "refresh") {
            onRefresh.call();
          }
        },
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
              text: AppStrings.PROFILE_EDIT,
              size: FontSizeConstants.X_SMALL,
              color: context.colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

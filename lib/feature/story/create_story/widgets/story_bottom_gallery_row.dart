import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/color/color.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class StoryBottomGalleryRow extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final Uint8List? galleryThumb;
  final bool isPhotoMode;
  final VoidCallback onPhotoTap;
  final VoidCallback onVideoTap;

  const StoryBottomGalleryRow({
    super.key,
    required this.onGalleryTap,
    required this.isPhotoMode,
    required this.onPhotoTap,
    required this.onVideoTap,
    this.galleryThumb,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * .04),
      child: Row(
        children: [
          _buildGalleryThumb(context),
          const Spacer(),
          GestureDetector(
            onTap: onPhotoTap,
            child: TextComponent(
              text: AppStrings.PROFILE_EDIT_STORY_PHOTO,
              size: const [15],
              color: isPhotoMode ? AppColors.WHITE : AppColors.WHITE_54,
              weight: isPhotoMode ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          SizedBox(width: context.width * .06),
          GestureDetector(
            onTap: onVideoTap,
            child: TextComponent(
              text: AppStrings.PROFILE_EDIT_STORY_VIDEO,
              size: const [15],
              color: !isPhotoMode ? AppColors.WHITE : AppColors.WHITE_54,
              weight: !isPhotoMode ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const Spacer(),
          SizedBox(width: context.width * .11),
        ],
      ),
    );
  }

  Widget _buildGalleryThumb(BuildContext context) {
    return GestureDetector(
      onTap: onGalleryTap,
      child: Container(
        width: context.width * .11,
        height: context.width * .11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.width * .025),
          border: Border.all(color: AppColors.WHITE_50, width: 1.5),
        ),
        child: galleryThumb != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(context.width * .02),
                child: Image.memory(galleryThumb!, fit: BoxFit.cover),
              )
            : Icon(
                Icons.photo_library,
                color: AppColors.WHITE,
                size: context.width * .055,
              ),
      ),
    );
  }
}

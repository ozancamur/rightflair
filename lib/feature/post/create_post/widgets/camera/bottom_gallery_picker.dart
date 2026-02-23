import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/string.dart';

class BottomGalleryPicker extends StatelessWidget {
  final VoidCallback onPickFromGallery;
  final Uint8List? latestGalleryImage;

  const BottomGalleryPicker({
    super.key,
    required this.onPickFromGallery,
    this.latestGalleryImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPickFromGallery,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.WHITE_50, width: 1.5),
              ),
              child: latestGalleryImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        latestGalleryImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.photo_library,
                      color: AppColors.WHITE,
                      size: 22,
                    ),
            ),
          ),
          const Spacer(),
          Text(
            AppStrings.PROFILE_EDIT_STORY_PHOTO.tr(),
            style: const TextStyle(
              color: AppColors.WHITE,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

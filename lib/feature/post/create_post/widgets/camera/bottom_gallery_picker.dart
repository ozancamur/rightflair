import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

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
      padding: EdgeInsets.symmetric(horizontal: context.width * .04),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPickFromGallery,
            child: Container(
              width: context.width * .11,
              height: context.width * .11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.width * .025),
                border: Border.all(color: AppColors.WHITE_50, width: 1.5),
              ),
              child: latestGalleryImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(context.width * .02),
                      child: Image.memory(
                        latestGalleryImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.photo_library,
                      color: AppColors.WHITE,
                      size: context.width * .055,
                    ),
            ),
          ),
          const Spacer(),
          TextComponent(
            text: AppStrings.PROFILE_EDIT_STORY_PHOTO,
            size: const [15],
            color: AppColors.WHITE,
            weight: FontWeight.w700,
          ),
          const Spacer(),
          SizedBox(width: context.width * .11),
        ],
      ),
    );
  }
}

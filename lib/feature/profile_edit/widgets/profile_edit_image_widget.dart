import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../core/components/profile/header/profile_photo.dart';

class ProfileEditImageWidget extends StatelessWidget {
  final String? imageUrl;
  final bool isUploading;
  final VoidCallback onTap;

  const ProfileEditImageWidget({
    super.key,
    required this.imageUrl,
    required this.onTap,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .16,
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_photo(context), _changePhotoText(context)],
      ),
    );
  }

  GestureDetector _photo(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: context.height * .12,
        width: context.height * .12,
        child: Stack(
          children: [
            ProfilePhotoComponent(url: imageUrl),
            Container(
              height: context.height * .12,
              width: context.height * .12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.75),
                border: Border.all(width: .5, color: Colors.white),
              ),
              child: isUploading
                  ? LoadingComponent()
                  : Center(
                      child: SvgPicture.asset(
                        AppIcons.CAMERA,
                        color: Colors.white,
                        height: context.height * .04,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _changePhotoText(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextComponent(
        text: AppStrings.PROFILE_EDIT_CHANGE_PHOTO,
        size: FontSizeConstants.NORMAL,
        color: context.colors.scrim,
        weight: FontWeight.w600,
      ),
    );
  }
}

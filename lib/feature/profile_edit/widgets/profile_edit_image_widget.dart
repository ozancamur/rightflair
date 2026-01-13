import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileEditImageWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const ProfileEditImageWidget({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: context.height * 0.015,
      children: [_profileImage(context), _changePhotoText(context)],
    );
  }

  Widget _profileImage(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: context.height * 0.13,
            width: context.height * 0.13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppDarkColors.WHITE16,
                width: context.width * 0.005,
              ),
              image: DecorationImage(
                image: NetworkImage(
                  imageUrl.isEmpty
                      ? "https://media.istockphoto.com/id/1495088043/tr/vekt%C3%B6r/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=1024x1024&w=is&k=20&c=gKLAWzRAE77Y213dcbWWxa_l3I4FqKoUNTX1gPk363E="
                      : imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: context.height * 0.13,
            width: context.height * 0.13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
            child: Center(
              child: SvgPicture.asset(
                AppIcons.CAMERA,
                height: context.height * 0.04,
                color: AppDarkColors.PRIMARY,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _changePhotoText(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextComponent(
        text: AppStrings.PROFILE_EDIT_CHANGE_PHOTO,
        size: FontSizeConstants.NORMAL,
        color: AppDarkColors.ORANGE,
        weight: FontWeight.w600,
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/feature/create_story/cubit/create_story_cubit.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/icons.dart';
import '../../../core/constants/media_picker_option.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';

Future<void> dialogCreateStory(
  BuildContext context, {
  required String uid,
}) async {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.colors.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.width * 0.05),
      ),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.all(context.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.width * 0.1,
            height: 4,
            margin: EdgeInsets.only(bottom: context.height * 0.02),
            decoration: BoxDecoration(
              color: context.colors.tertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          TextComponent(
            text: AppStrings.PROFILE_EDIT_SELECT_SOURCE.tr(),
            color: context.colors.primary,
            size: FontSizeConstants.LARGE,
            weight: FontWeight.w600,
          ),
          SizedBox(height: context.height * 0.02),
          ListTile(
            leading: SvgPicture.asset(
              AppIcons.CAMERA,
              color: context.colors.primary,
              height: context.height * .03,
            ),
            title: TextComponent(
              text: AppStrings.PROFILE_EDIT_CAMERA.tr(),
              color: context.colors.primary,
              weight: FontWeight.w500,
              size: FontSizeConstants.NORMAL,
            ),
            onTap: () => context.read<CreateStoryCubit>().select(
              context,
              uid: uid,
              option: MediaPickerOption.camera,
            ),
          ),
          Divider(color: context.colors.tertiary, thickness: .25, height: .25),
          ListTile(
            leading: SvgPicture.asset(
              AppIcons.GALLERY,
              color: context.colors.primary,
              height: context.height * .03,
            ),
            title: TextComponent(
              text: AppStrings.PROFILE_EDIT_GALLERY.tr(),
              color: context.colors.primary,
              weight: FontWeight.w500,
              size: FontSizeConstants.NORMAL,
            ),
            onTap: () => context.read<CreateStoryCubit>().select(
              context,
              uid: uid,
              option: MediaPickerOption.gallery,
            ),
          ),
          SizedBox(height: context.height * 0.02),
        ],
      ),
    ),
  );
}

// Eski fonksiyon - geriye dönük uyumluluk için
enum ImagePickerOption { camera, gallery }

Future<ImagePickerOption?> dialogPickImage(BuildContext context) async {
  return showModalBottomSheet<ImagePickerOption>(
    context: context,
    backgroundColor: context.colors.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.width * 0.05),
      ),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.all(context.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.width * 0.1,
            height: 4,
            margin: EdgeInsets.only(bottom: context.height * 0.02),
            decoration: BoxDecoration(
              color: context.colors.tertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          TextComponent(
            text: AppStrings.PROFILE_EDIT_SELECT_PHOTO.tr(),
            color: context.colors.primary,
            size: FontSizeConstants.LARGE,
            weight: FontWeight.w600,
          ),
          SizedBox(height: context.height * 0.02),
          ListTile(
            leading: SvgPicture.asset(
              AppIcons.CAMERA,
              color: context.colors.primary,
              height: context.height * .03,
            ),
            title: TextComponent(
              text: AppStrings.PROFILE_EDIT_TAKE_PHOTO.tr(),
              color: context.colors.primary,
              weight: FontWeight.w500,
              size: FontSizeConstants.NORMAL,
            ),
            onTap: () => Navigator.pop(context, ImagePickerOption.camera),
          ),
          Divider(color: context.colors.tertiary, thickness: .25, height: .25),
          ListTile(
            leading: SvgPicture.asset(
              AppIcons.GALLERY,
              color: context.colors.primary,
              height: context.height * .03,
            ),
            title: TextComponent(
              text: AppStrings.PROFILE_EDIT_CHOOSE_FROM_GALLERY.tr(),
              color: context.colors.primary,
              weight: FontWeight.w500,
              size: FontSizeConstants.NORMAL,
            ),
            onTap: () => Navigator.pop(context, ImagePickerOption.gallery),
          ),
          SizedBox(height: context.height * 0.02),
        ],
      ),
    ),
  );
}

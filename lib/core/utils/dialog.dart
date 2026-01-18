import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../feature/profile_edit/cubit/profile_edit_cubit.dart';
import '../extensions/context.dart';

class DialogUtils {
  DialogUtils._();

  /// Hata dialogu göster
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String message,
    String? title,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: title != null
              ? SizedBox(
                  width: double.maxFinite,
                  child: TextComponent(
                    text: title,
                    color: context.colors.primary,
                    size: FontSizeConstants.X_LARGE,
                    weight: FontWeight.w600,
                  ),
                )
              : null,
          content: SizedBox(
            width: double.maxFinite,
            child: TextComponent(
              text: message,
              color: context.colors.primaryContainer,
              size: FontSizeConstants.NORMAL,
              weight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: TextComponent(
                text: AppStrings.DIALOG_OK,
                color: Colors.red,
                size: FontSizeConstants.LARGE,
                weight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Başarı dialogu göster
  static Future<void> showSuccessDialog(
    BuildContext context, {
    required String message,
    String? title,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: title != null
              ? SizedBox(
                  width: double.maxFinite,
                  child: TextComponent(
                    text: title,
                    color: context.colors.primary,
                    size: FontSizeConstants.X_LARGE,
                    weight: FontWeight.w600,
                  ),
                )
              : null,
          content: SizedBox(
            width: double.maxFinite,
            child: TextComponent(
              text: message,
              color: context.colors.primaryContainer,
              size: FontSizeConstants.NORMAL,
              weight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: TextComponent(
                text: AppStrings.DIALOG_OK,
                color: context.colors.inverseSurface,
                size: FontSizeConstants.LARGE,
                weight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Onay dialogu göster
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String message,
    String? title,
    String? confirmText,
    String? cancelText,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: title != null
              ? SizedBox(
                  width: double.maxFinite,
                  child: TextComponent(
                    text: title,
                    color: context.colors.primary,
                    size: FontSizeConstants.X_LARGE,
                    weight: FontWeight.w600,
                  ),
                )
              : null,
          content: SizedBox(
            width: double.maxFinite,
            child: TextComponent(
              text: message,
              color: context.colors.primaryContainer,
              size: FontSizeConstants.NORMAL,
              weight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: TextComponent(
                text: cancelText ?? AppStrings.DIALOG_CANCEL,
                color: context.colors.primaryContainer,
                size: FontSizeConstants.LARGE,
                weight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: TextComponent(
                text: confirmText ?? AppStrings.DIALOG_CONFIRM,
                color: Colors.red,
                size: FontSizeConstants.LARGE,
                weight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  static void showSelectMyStyles(BuildContext context) {
    final styles = [
      'Oversized',
      'Streetwear',
      'Modeling',
      'Casual',
      'Formal',
      'Vintage',
      'Sporty',
      'Bohemian',
      'Y2K',
      'Goth',
      'Minimalist',
      'Techwear',
      'Skater',
      'Retro',
      'Clean',
      'Girl',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.width * 0.05),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(context.width * 0.05),
        child: SizedBox(
          height: context.height * .5,
          width: context.width,
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: context.colors.tertiary,
              thickness: .25,
              height: .25,
            ),
            itemCount: styles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: TextComponent(
                  text: styles[index],
                  color: context.colors.primary,
                  weight: FontWeight.w500,
                  size: FontSizeConstants.LARGE,
                ),
                onTap: () {
                  context.read<ProfileEditCubit>().addStyle(styles[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/constants/string.dart';

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
          backgroundColor: AppDarkColors.SECONDARY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: title != null
              ? SizedBox(
                  width: double.maxFinite,
                  child: TextComponent(
                    text: title,
                    color: AppDarkColors.PRIMARY,
                    size: FontSizeConstants.X_LARGE,
                    weight: FontWeight.w600,
                  ),
                )
              : null,
          content: SizedBox(
            width: double.maxFinite,
            child: TextComponent(
              text: message,
              color: AppDarkColors.WHITE75,
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
          backgroundColor: AppDarkColors.SECONDARY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: title != null
              ? SizedBox(
                  width: double.maxFinite,
                  child: TextComponent(
                    text: title,
                    color: AppDarkColors.PRIMARY,
                    size: FontSizeConstants.X_LARGE,
                    weight: FontWeight.w600,
                  ),
                )
              : null,
          content: SizedBox(
            width: double.maxFinite,
            child: TextComponent(
              text: message,
              color: AppDarkColors.WHITE75,
              size: FontSizeConstants.NORMAL,
              weight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: TextComponent(
                text: AppStrings.DIALOG_OK,
                color: AppDarkColors.GREEN,
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
          backgroundColor: AppDarkColors.SECONDARY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: title != null
              ? SizedBox(
                  width: double.maxFinite,
                  child: TextComponent(
                    text: title,
                    color: AppDarkColors.PRIMARY,
                    size: FontSizeConstants.X_LARGE,
                    weight: FontWeight.w600,
                  ),
                )
              : null,
          content: SizedBox(
            width: double.maxFinite,
            child: TextComponent(
              text: message,
              color: AppDarkColors.WHITE75,
              size: FontSizeConstants.NORMAL,
              weight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: TextComponent(
                text: cancelText ?? AppStrings.DIALOG_CANCEL,
                color: AppDarkColors.WHITE75,
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
}

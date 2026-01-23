import 'package:flutter/material.dart';

import '../../components/text.dart';
import '../../constants/font/font_size.dart';
import '../../constants/string.dart';
import '../../extensions/context.dart';

Future<void> dialogError(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

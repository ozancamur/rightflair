import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/button/elevated_button.dart';

import '../../components/text/text.dart';
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
      return Dialog(
        backgroundColor: context.colors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: context.colors.error, width: .25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                TextComponent(
                  text: title,
                  color: context.colors.primary,
                  size: FontSizeConstants.X_LARGE,
                  weight: FontWeight.w600,
                  align: TextAlign.center,
                ),
                SizedBox(height: context.height * 0.025),
              ],
              TextComponent(
                text: message,
                color: context.colors.primaryContainer,
                size: FontSizeConstants.NORMAL,
                weight: FontWeight.w400,
                align: TextAlign.center,
              ),
              SizedBox(height: context.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * .25),
                child: ElevatedButtonComponent(
                  radius: 12,
                  height: context.height * .05,
                  color: context.colors.error.withOpacity(.75),
                  child: TextComponent(
                    text: AppStrings.DIALOG_OK,
                    color: context.colors.primary,
                    size: FontSizeConstants.LARGE,
                    weight: FontWeight.w600,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

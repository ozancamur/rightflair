import 'package:flutter/material.dart';

import '../../components/text/text.dart';
import '../../constants/font/font_size.dart';
import '../../constants/string.dart';
import '../../extensions/context.dart';

Future<void> dialogConfirm(
  BuildContext context, {
  required String message,
  String? title,
  required Future<void> Function() onConfirm,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: context.colors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                TextComponent(
                  text: title,
                  color: context.colors.primary,
                  size: FontSizeConstants.X_LARGE,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 16),
              ],
              TextComponent(
                text: message,
                color: context.colors.primaryContainer,
                size: FontSizeConstants.NORMAL,
                weight: FontWeight.w400,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: TextComponent(
                      text: AppStrings.DIALOG_CANCEL,
                      color: context.colors.primaryContainer,
                      size: FontSizeConstants.LARGE,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: TextComponent(
                      text: AppStrings.DIALOG_CONFIRM,
                      color: Colors.red,
                      size: FontSizeConstants.LARGE,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  if (confirmed == true) {
    await onConfirm();
  }
}

import 'package:flutter/material.dart';

import '../components/text/text.dart';
import '../constants/string.dart';
import '../extensions/context.dart';

void dialogConfirmation(
  BuildContext context, {
  required String actionTitle,
  required String confirmMessage,
  required VoidCallback onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.colors.secondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.06,
          vertical: context.height * 0.01,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.width * 0.1,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: context.height * 0.015),
            TextComponent(
              text: confirmMessage,
              color: Colors.white.withOpacity(0.75),
              weight: FontWeight.w400,
              size: [context.width * 0.035],
            ),
            SizedBox(height: context.height * 0.02),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.secondary,
                  foregroundColor: context.colors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: context.height * 0.015,
                  ),
                ),
                child: TextComponent(
                  text: actionTitle,
                  color: context.colors.error,
                  weight: FontWeight.w600,
                  size: [context.width * 0.04],
                ),
              ),
            ),
            SizedBox(height: context.height * 0.01),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.secondary,
                  foregroundColor: context.colors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: context.height * 0.015,
                  ),
                ),
                child: TextComponent(
                  text: AppStrings.DIALOG_CANCEL,
                  color: context.colors.primary,
                  weight: FontWeight.w600,
                  size: [context.width * 0.04],
                ),
              ),
            ),
            SizedBox(height: context.height * 0.01),
          ],
        ),
      ),
    ),
  );
}

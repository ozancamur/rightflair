import 'package:flutter/material.dart';

import '../components/text/text.dart';
import '../constants/font/font_size.dart';
import '../constants/string.dart';
import '../extensions/context.dart';

class ReportSuccessDialog {
  ReportSuccessDialog._();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _ReportSuccessPopup(),
    );
  }
}

class _ReportSuccessPopup extends StatelessWidget {
  const _ReportSuccessPopup();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.width * 0.04),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.06,
          vertical: context.height * 0.035,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(context.width * 0.04),
              decoration: BoxDecoration(
                color: context.colors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: context.colors.error,
                size: context.width * 0.1,
              ),
            ),
            SizedBox(height: context.height * 0.02),
            TextComponent(
              text: AppStrings.REPORT_SENT_TITLE,
              size: FontSizeConstants.X_LARGE,
              weight: FontWeight.w600,
              color: context.colors.primary,
            ),
            SizedBox(height: context.height * 0.01),
            TextComponent(
              text: AppStrings.REPORT_SENT_DESCRIPTION,
              size: FontSizeConstants.SMALL,
              color: context.colors.primary.withValues(alpha: 0.6),
              align: TextAlign.center,
              height: 1.4,
            ),
            SizedBox(height: context.height * 0.025),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.error,
                  padding: EdgeInsets.symmetric(
                    vertical: context.height * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.width * 0.03),
                  ),
                ),
                child: TextComponent(
                  text: AppStrings.REPORT_SENT_OK,
                  size: FontSizeConstants.NORMAL,
                  weight: FontWeight.w600,
                  color: context.colors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

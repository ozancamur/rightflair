import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class PreviewActionButtons extends StatelessWidget {
  final VoidCallback onRetake;
  final VoidCallback onContinue;

  const PreviewActionButtons({
    super.key,
    required this.onRetake,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onRetake,
            child: Container(
              height: context.height * .06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.width * .065),
                border: Border.all(color: AppColors.WHITE, width: 1.5),
              ),
              child: Center(
                child: TextComponent(
                  text: AppStrings.CREATE_POST_CAMERA_RETAKE,
                  size: const [15],
                  color: AppColors.WHITE,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: context.width * .03),
        Expanded(
          child: GestureDetector(
            onTap: onContinue,
            child: Container(
              height: context.height * .06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.width * .065),
                gradient: LinearGradient(
                  colors: [AppColors.ORANGE, AppColors.YELLOW],
                ),
              ),
              child: Center(
                child: TextComponent(
                  text: AppStrings.CREATE_POST_CAMERA_CONTINUE,
                  size: const [15],
                  color: AppColors.WHITE,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

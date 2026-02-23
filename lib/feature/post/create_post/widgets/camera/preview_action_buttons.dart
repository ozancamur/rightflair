import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/string.dart';

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
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.WHITE, width: 1.5),
              ),
              child: Center(
                child: Text(
                  AppStrings.CREATE_POST_CAMERA_RETAKE.tr(),
                  style: const TextStyle(
                    color: AppColors.WHITE,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onContinue,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [AppColors.ORANGE, AppColors.YELLOW],
                ),
              ),
              child: Center(
                child: Text(
                  AppStrings.CREATE_POST_CAMERA_CONTINUE.tr(),
                  style: const TextStyle(
                    color: AppColors.WHITE,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

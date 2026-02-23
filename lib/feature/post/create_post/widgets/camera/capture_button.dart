import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';

class CaptureButton extends StatelessWidget {
  final VoidCallback onTap;

  const CaptureButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.WHITE, width: 4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.WHITE,
            ),
          ),
        ),
      ),
    );
  }
}

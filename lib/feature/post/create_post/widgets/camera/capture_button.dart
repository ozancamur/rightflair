import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/extensions/context.dart';

class CaptureButton extends StatelessWidget {
  final VoidCallback onTap;

  const CaptureButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = context.width * .195;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.WHITE, width: 4),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.width * .01),
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

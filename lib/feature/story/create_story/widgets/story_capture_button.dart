import 'package:flutter/material.dart';

import '../../../../core/constants/color/color.dart';
import '../../../../core/extensions/context.dart';

class StoryCaptureButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isRecording;

  const StoryCaptureButton({
    super.key,
    required this.onTap,
    this.isRecording = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: context.width * .19,
          height: context.width * .19,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.WHITE, width: 4),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.width * .01),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecording ? AppColors.ORANGE : AppColors.WHITE,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

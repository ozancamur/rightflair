import 'package:flutter/material.dart';

import '../../../../core/constants/color/color.dart';
import '../../../../core/extensions/context.dart';

class StoryCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const StoryCircleIconButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width * .1,
        height: context.width * .1,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.BLACK_30,
        ),
        child: Icon(icon, color: AppColors.WHITE, size: context.width * .06),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../constants/color/color.dart';
import '../../../extensions/context.dart';

class StoryRingWidget extends StatelessWidget {
  final Widget child;
  final bool hasStories;
  final bool hasUnseen;
  final VoidCallback? onTap;

  const StoryRingWidget({
    super.key,
    required this.child,
    required this.hasStories,
    required this.hasUnseen,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasStories) return child;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: hasUnseen ? _activeGradient() : null,
          color: hasUnseen ? null : Colors.grey,
        ),
        child: Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.secondary,
          ),
          child: child,
        ),
      ),
    );
  }

  SweepGradient _activeGradient() {
    return SweepGradient(
      colors: [
        AppColors.ORANGE,
        AppColors.YELLOW,
        AppColors.ORANGE,
        AppColors.YELLOW,
        AppColors.ORANGE,
      ],
    );
  }
}

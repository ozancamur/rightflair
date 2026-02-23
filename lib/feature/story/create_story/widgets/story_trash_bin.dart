import 'package:flutter/material.dart';

import '../../../../core/constants/color/color.dart';
import '../../../../core/extensions/context.dart';

class StoryTrashBin extends StatelessWidget {
  final GlobalKey trashKey;
  final bool isOverTrash;

  const StoryTrashBin({
    super.key,
    required this.trashKey,
    required this.isOverTrash,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isOverTrash ? 1.3 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Container(
        key: trashKey,
        width: context.width * .14,
        height: context.width * .14,
        decoration: BoxDecoration(
          color: isOverTrash ? Colors.red : AppColors.BLACK.withOpacity(0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: isOverTrash ? Colors.red.shade300 : AppColors.WHITE_54,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.delete,
          color: AppColors.WHITE,
          size: isOverTrash ? context.width * .075 : context.width * .065,
        ),
      ),
    );
  }
}

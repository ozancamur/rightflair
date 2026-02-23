import 'package:flutter/material.dart';

import '../../../../core/constants/color/color.dart';
import '../../../../core/extensions/context.dart';

class StorySideToolbarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool hasBadge;

  const StorySideToolbarIcon({
    super.key,
    required this.icon,
    this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: AppColors.WHITE, size: context.width * .07),
          if (hasBadge)
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: context.width * .025,
                height: context.width * .025,
                decoration: BoxDecoration(
                  color: AppColors.ORANGE,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.BLACK, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

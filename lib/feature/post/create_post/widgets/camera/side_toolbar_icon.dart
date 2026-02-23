import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';

class SideToolbarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool hasBadge;

  const SideToolbarIcon({
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
          Icon(icon, color: AppColors.WHITE, size: 28),
          if (hasBadge)
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.RED_ACCENT,
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

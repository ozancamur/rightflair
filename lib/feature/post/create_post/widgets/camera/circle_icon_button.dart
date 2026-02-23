import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CircleIconButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.BLACK_30,
        ),
        child: Icon(icon, color: AppColors.WHITE, size: 24),
      ),
    );
  }
}

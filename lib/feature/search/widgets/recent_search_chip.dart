import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/extensions/context.dart';

class RecentSearchChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RecentSearchChip({
    super.key,
    required this.label,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.04,
          vertical: context.height * 0.012,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppDarkColors.WHITE32, width: 1),
          borderRadius: BorderRadius.circular(context.width * 0.06),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppDarkColors.PRIMARY,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

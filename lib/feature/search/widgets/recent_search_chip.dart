import 'package:flutter/material.dart';
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
          vertical: context.height * 0.005,
        ),
        decoration: BoxDecoration(
          color: context.colors.onBackground,
          border: Border.all(color: context.colors.onPrimaryFixed, width: .5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: context.colors.primary,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

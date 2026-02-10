import 'package:flutter/material.dart';

import '../../../../../core/extensions/context.dart';

class CreateTagButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const CreateTagButtonWidget({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width * 0.08,
        height: context.width * 0.08,
        decoration: BoxDecoration(
          color: context.colors.primaryFixedDim,
          borderRadius: BorderRadius.circular(context.width * 0.02),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: context.colors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

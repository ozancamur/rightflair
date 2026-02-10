import 'package:flutter/material.dart';
import 'package:rightflair/core/components/button/icon_button.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

class PostDetailTopButtonsWidget extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const PostDetailTopButtonsWidget({
    super.key,
    required this.onBackTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.05,
        vertical: context.height * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButtonComponent(icon: AppIcons.BACK, onTap: onBackTap),
          Row(
            spacing: context.width * 0.03,
            children: [
              IconButtonComponent(icon: AppIcons.EDIT, onTap: onEditTap),
              IconButtonComponent(icon: AppIcons.DELETE, onTap: onDeleteTap),
            ],
          ),
        ],
      ),
    );
  }
}

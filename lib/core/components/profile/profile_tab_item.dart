import 'package:flutter/material.dart';

import '../../../../../core/components/text.dart';
import '../../constants/font/font_size.dart';
import '../../../../../core/extensions/context.dart';

class ProfileTabItemComponent extends StatelessWidget {
  final String text;
  const ProfileTabItemComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: context.height * 0.005,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextComponent(
            text: text,
            size: FontSizeConstants.LARGE,
            weight: FontWeight.w600,
            color: context.colors.primary,
          ),
          Container(
            height: context.height * 0.003,
            width: context.width * 0.1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.colors.surface, context.colors.scrim],
              ),
              borderRadius: BorderRadius.circular(context.width * 0.01),
            ),
          ),
        ],
      ),
    );
  }
}

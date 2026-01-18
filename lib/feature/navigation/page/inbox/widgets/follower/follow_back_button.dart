import 'package:flutter/material.dart';

import '../../../../../../core/components/text.dart';
import '../../../../../../core/constants/font/font_size.dart';
import '../../../../../../core/extensions/context.dart';

class FollowBackButtonWidget extends StatelessWidget {
  const FollowBackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.01,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.surface, context.colors.scrim],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextComponent(
        text: 'Follow back',
        size: FontSizeConstants.XX_SMALL,
        weight: FontWeight.w500,
        color: Colors.white,
        tr: false,
      ),
    );
  }
}

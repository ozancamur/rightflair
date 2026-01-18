import 'package:flutter/material.dart';

import '../../../../../../core/components/text.dart';
import '../../../../../../core/constants/font/font_size.dart';
import '../../../../../../core/extensions/context.dart';

class SuggestedAccountUserWidget extends StatelessWidget {
  final String username;
  final String handle;
  const SuggestedAccountUserWidget({
    super.key,
    required this.username,
    required this.handle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * 0.003,
        children: [
          TextComponent(
            text: username,
            size: FontSizeConstants.SMALL,
            weight: FontWeight.w600,
            tr: false,
            color: context.colors.primary,
          ),
          TextComponent(
            text: handle,
            size: FontSizeConstants.XX_SMALL,
            color: context.colors.tertiary,
            tr: false,
          ),
        ],
      ),
    );
  }
}

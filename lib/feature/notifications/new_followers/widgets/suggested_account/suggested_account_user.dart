import 'package:flutter/material.dart';

import '../../../../../core/components/text/text.dart';
import '../../../../../core/constants/font/font_size.dart';
import '../../../../../core/extensions/context.dart';

class SuggestedAccountUserWidget extends StatelessWidget {
  final String? fullname;
  final String? username;
  const SuggestedAccountUserWidget({
    super.key,
    required this.fullname,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * 0.003,
        children: [
          TextComponent(
            text: fullname ?? "Rightflair User",
            size: FontSizeConstants.SMALL,
            weight: FontWeight.w600,
            tr: false,
            color: context.colors.primary,
          ),
          TextComponent(
            text: username ?? "@rightflair_user",
            size: FontSizeConstants.XX_SMALL,
            color: context.colors.tertiary,
            tr: false,
          ),
        ],
      ),
    );
  }
}

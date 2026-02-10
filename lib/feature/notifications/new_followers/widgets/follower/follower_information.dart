import 'package:flutter/material.dart';

import '../../../../../core/components/text/text.dart';
import '../../../../../core/constants/font/font_size.dart';
import '../../../../../core/extensions/context.dart';

class FollowerInformationWidget extends StatelessWidget {
  final String username;
  final String subtitle;
  final String timeAgo;
  const FollowerInformationWidget({
    super.key,
    required this.username,
    required this.subtitle,
    required this.timeAgo,
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
            color: context.colors.primary,
            tr: false,
          ),
          Row(
            children: [
              Expanded(
                child: TextComponent(
                  text: subtitle,
                  size: FontSizeConstants.XX_SMALL,
                  color: context.colors.primary.withOpacity(.65),
                ),
              ),
              TextComponent(
                text: ' • $timeAgo',
                size: FontSizeConstants.XX_SMALL,
                color: context.colors.primary.withOpacity(.65),
                tr: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

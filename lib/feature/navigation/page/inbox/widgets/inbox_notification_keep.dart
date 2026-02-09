import 'package:flutter/material.dart';

import '../../../../../core/components/text/text.dart';
import '../../../../../core/constants/font/font_size.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';

class InboxNotificationKeep extends StatelessWidget {
  const InboxNotificationKeep({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.height * 0.02),
      padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.onSecondary,
        border: Border.all(color: context.colors.onTertiary.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextComponent(
          text: AppStrings.INBOX_KEEP_POSTING,
          color: context.colors.primary,
          size: FontSizeConstants.SMALL,
        ),
      ),
    );
  }
}

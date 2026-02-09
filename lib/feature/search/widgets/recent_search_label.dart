import 'package:flutter/widgets.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';

class RecentSearchLabelWidget extends StatelessWidget {
  const RecentSearchLabelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.01),
      child: TextComponent(
        text: AppStrings.SEARCH_RECENT_SEARCHES,
        color: context.colors.primaryContainer,
        size: FontSizeConstants.SMALL,
        weight: FontWeight.w600,
        spacing: 0.5,
      ),
    );
  }
}

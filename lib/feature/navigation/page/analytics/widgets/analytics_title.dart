import 'package:flutter/material.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';

class AnalyticsTitleWidget extends StatelessWidget {
  const AnalyticsTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextComponent(
        text: AppStrings.ANALYTICS_TITLE,
        size: [context.width * 0.05],
        weight: FontWeight.w600,
      ),
    );
  }
}

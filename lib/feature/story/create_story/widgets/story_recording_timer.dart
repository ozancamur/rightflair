import 'package:flutter/material.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/color/color.dart';
import '../../../../core/extensions/context.dart';

class StoryRecordingTimer extends StatelessWidget {
  final String formattedTime;

  const StoryRecordingTimer({super.key, required this.formattedTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.height * .019),
      padding: EdgeInsets.symmetric(
        horizontal: context.width * .04,
        vertical: context.height * .007,
      ),
      decoration: BoxDecoration(
        color: AppColors.ORANGE,
        borderRadius: BorderRadius.circular(context.width * .05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.width * .02,
            height: context.width * .02,
            decoration: const BoxDecoration(
              color: AppColors.WHITE,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.width * .02),
          TextComponent(
            text: formattedTime,
            tr: false,
            size: const [14],
            color: AppColors.WHITE,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class CommentsHeaderWidget extends StatelessWidget {
  final int commentCount;
  const CommentsHeaderWidget({super.key, required this.commentCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextComponent(
            text: '$commentCount ${AppStrings.COMMENTS_TITLE.tr()}',
            size: FontSizeConstants.LARGE,
            color: context.colors.primary,
            weight: FontWeight.w600,
            tr: false,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(context.width * 0.01),
              child: Icon(
                Icons.close,
                color: context.colors.primary,
                size: context.width * 0.06,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

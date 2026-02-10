import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../../../core/extensions/context.dart';

class CommentTextWidget extends StatelessWidget {
  final String text;
  const CommentTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextComponent(
      text: text,
      color: context.colors.primary.withOpacity(0.9),
      size: FontSizeConstants.SMALL,
      height: 1.4,
      tr: false,
    );
  }
}

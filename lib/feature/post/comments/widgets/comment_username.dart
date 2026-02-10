import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../../../core/extensions/context.dart';

class CommentUsernameWidget extends StatelessWidget {
  final String username;
  const CommentUsernameWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return TextComponent(
      text: username,
      color: context.colors.primary,
      size: FontSizeConstants.NORMAL,
      weight: FontWeight.w600,
      tr: false,
    );
  }
}

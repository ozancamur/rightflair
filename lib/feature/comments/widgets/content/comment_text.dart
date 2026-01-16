import 'package:flutter/material.dart';

import '../../../../core/constants/dark_color.dart';

class CommentTextWidget extends StatelessWidget {
  final String text;
  const CommentTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppDarkColors.PRIMARY.withOpacity(0.9),
        fontSize: 14,
        height: 1.4,
      ),
    );
  }
}

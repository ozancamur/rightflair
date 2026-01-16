import 'package:flutter/material.dart';

import '../../../../core/constants/dark_color.dart';

class CommentUsernameWidget extends StatelessWidget {
  final String username;
  const CommentUsernameWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Text(
      username,
      style: TextStyle(
        color: AppDarkColors.PRIMARY,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';

class CommentAvatarWidget extends StatelessWidget {
  final String? avatar;
  final String username;
  const CommentAvatarWidget({
    super.key,
    required this.avatar,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[800],
      backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
      child: avatar == null
          ? Text(
              username[0].toUpperCase(),
              style:  TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}

import 'package:flutter/material.dart';

class CommentUsernameWidget extends StatelessWidget {
  final String username;
  const CommentUsernameWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Text(
      username,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CommentTextWidget extends StatelessWidget {
  final String text;
  const CommentTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 14,
        height: 1.4,
      ),
    );
  }
}

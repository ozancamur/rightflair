import 'package:flutter/material.dart';

class CommentTimeAndReplyWidget extends StatelessWidget {
  final String timeAgo;
  const CommentTimeAndReplyWidget({super.key, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          timeAgo,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            // Handle reply
          },
          child: Text(
            'Reply',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

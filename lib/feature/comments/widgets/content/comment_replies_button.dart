import 'package:flutter/material.dart';

class CommentRepliesButtonWidget extends StatelessWidget {
  final int replyCount;
  const CommentRepliesButtonWidget({super.key, required this.replyCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: () {
          // Handle view replies
        },
        child: Row(
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'View $replyCount replies',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';

class CommentLikeButtonWidget extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  const CommentLikeButtonWidget({
    super.key,
    required this.isLiked,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Handle like
          },
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked
                ? Colors.red
                : context.colors.primary.withOpacity(0.7),
            size: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$likeCount',
          style: TextStyle(
            color: context.colors.primary.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

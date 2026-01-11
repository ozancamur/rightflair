import 'package:flutter/material.dart';

class CommentsHeaderWidget extends StatelessWidget {
  final int commentCount;
  const CommentsHeaderWidget({super.key, required this.commentCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$commentCount comments',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

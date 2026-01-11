import 'package:flutter/material.dart';

class AddCommentWidget extends StatelessWidget {
  final Function(String) onAddComment;
  AddCommentWidget({super.key, required this.onAddComment});

  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.grey[800]),
          const SizedBox(width: 12),

          // Text Input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Add comment..',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Send Button
          GestureDetector(
            onTap: () {
              if (_commentController.text.trim().isNotEmpty) {
                onAddComment(_commentController.text.trim());
                _commentController.clear();
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFF8C00),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

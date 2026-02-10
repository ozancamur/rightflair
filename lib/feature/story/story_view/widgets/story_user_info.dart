import 'package:flutter/material.dart';
import 'package:rightflair/feature/main/feed/models/story_user.dart';

class StoryUserInfo extends StatelessWidget {
  final StoryUserModel? user;
  final DateTime? createdAt;
  final VoidCallback onClose;

  const StoryUserInfo({
    super.key,
    required this.user,
    this.createdAt,
    required this.onClose,
  });

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile picture
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade800,
          backgroundImage: user?.profilePhotoUrl != null
              ? NetworkImage(user!.profilePhotoUrl!)
              : null,
          child: user?.profilePhotoUrl == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),

        // Username and time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user?.username ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (createdAt != null)
                Text(
                  _getTimeAgo(createdAt!),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),

        // Close button
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}

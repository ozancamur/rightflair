import 'package:rightflair/feature/navigation/page/inbox/model/notification_model.dart';

import 'package:rightflair/core/constants/string.dart';

import '../model/comment.dart';
import '../model/notification_type.dart';
import 'inbox_repository.dart';

class InboxRepositoryImpl implements InboxRepository {
  
  @override
  Future<List<CommentModel>> getMessages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      CommentModel(
        id: '1',
        ownerId: 'Elena Miles',
        image: 'https://i.pravatar.cc/150?u=1',
        message: 'Omg I love that jacket! Where did you...',
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      CommentModel(
        id: '2',
        ownerId: 'Sophie Turner',
        image: 'https://i.pravatar.cc/150?u=2',
        message: 'Can we collab on the next shoot?',
        createdAt: DateTime.now().subtract(const Duration(hours: 19)),
      ),
      CommentModel(
        id: '3',
        ownerId: 'Alex Johnson',
        image: 'https://i.pravatar.cc/150?u=3',
        message: AppStrings
            .INBOX_SENT_A_PHOTO, // Use key to simulate "Sent a photo" logic if needed, or just plain text if localized in UI
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const NotificationModel(
        id: '1',
        title: 'Your outfit is trending',
        timeAgo: '', // No time shown in design
        type: NotificationType.trending,
      ),
      const NotificationModel(
        id: '2',
        title: '23 people liked your outfit',
        timeAgo: '12m',
        type: NotificationType.like,
      ),
      const NotificationModel(
        id: '3',
        title: 'Your outfit reached 1,000 views',
        timeAgo: '1h',
        type: NotificationType.view,
      ),
      const NotificationModel(
        id: '4',
        title: '8 people saved your outfit',
        timeAgo: '2h',
        type: NotificationType.save,
      ),
      const NotificationModel(
        id: '5',
        title: '10 people shared your outfit',
        timeAgo: '2d',
        type: NotificationType.share,
      ),
      const NotificationModel(
        id: '6',
        title: 'New followers',
        subtitle: 'angi started follow you.',
        timeAgo: '',
        type: NotificationType.newFollower,
      ),
      const NotificationModel(
        id: '7',
        title: 'System notifications',
        subtitle: 'Account updates: was removed be..',
        timeAgo: '4h',
        type: NotificationType.system,
      ),
    ];
  }
}

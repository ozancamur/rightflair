import '../model/comment.dart';
import '../model/notification_model.dart';

abstract class InboxRepository {
  Future<List<CommentModel>> getMessages();
  Future<List<NotificationModel>> getNotifications();

}

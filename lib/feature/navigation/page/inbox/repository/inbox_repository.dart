import '../model/message.dart';
import '../model/notification_model.dart';

abstract class InboxRepository {
  Future<List<MessageModel>> getMessages();
  Future<List<NotificationModel>> getNotifications();
}

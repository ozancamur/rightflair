import 'package:rightflair/feature/main/profile/model/pagination.dart';

import '../model/conversations.dart';
import '../model/response_notifications.dart';

abstract class InboxRepository {
  Future<ConversationsModel?> getConversations({
    required PaginationModel pagination,
  });
  Future<ResponseNotificationsModel?> getActivityNotifications();
  Future<ResponseNotificationsModel?> getSystemNotifications();
}

import 'package:rightflair/feature/main/profile/model/pagination.dart';

import '../model/conversations.dart';
import '../model/response_message_requests.dart';
import '../model/response_notifications.dart';

abstract class InboxRepository {
  Future<ConversationsModel?> getConversations({
    required PaginationModel pagination,
  });
  Future<ResponseNotificationsModel?> getActivityNotifications({
    int page = 1,
    int limit = 10,
    bool? markAsRead,
  });
  Future<ResponseMessageRequestsModel?> getMessageRequests({
    int page = 1,
    int limit = 20,
  });
  Future<bool> acceptMessageRequest({required String conversationId});
  Future<bool> declineMessageRequest({required String conversationId});
}

import 'package:rightflair/feature/navigation/page/profile/model/pagination.dart';

import '../model/conversations.dart';

abstract class InboxRepository {
  Future<ConversationsModel?> fetchConversations({required PaginationModel pagination});
}

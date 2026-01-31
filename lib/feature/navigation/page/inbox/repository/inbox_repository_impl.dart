import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/feature/navigation/page/inbox/model/conversations.dart';

import '../../../../../core/base/model/response.dart';
import '../../../../../core/services/api.dart';
import '../../profile/model/pagination.dart';
import 'inbox_repository.dart';

class InboxRepositoryImpl implements InboxRepository {
  final ApiService _api;
  InboxRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<ConversationsModel?> fetchConversations({
    required PaginationModel pagination,
  }) async {
    try {
      final request = await _api.get(
        Endpoint.GET_CONVERSATIONS,
        data: pagination.toJson(),
      );
      final response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      final ConversationsModel conversations = ConversationsModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return conversations;
    } catch (e) {
      debugPrint("InboxRepositoryImpl ERROR in fetchConversations: $e");
      return null;
    }
  }
}

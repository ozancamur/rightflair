import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';
import 'package:rightflair/feature/main/inbox/model/conversations.dart';

import '../../../../core/base/model/response.dart';
import '../../../../core/services/api.dart';
import '../../profile/model/pagination.dart';
import '../model/response_message_requests.dart';
import '../model/response_notifications.dart';
import 'inbox_repository.dart';

class InboxRepositoryImpl implements InboxRepository {
  final ApiService _api;
  InboxRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<ConversationsModel?> getConversations({
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

  @override
  Future<ResponseNotificationsModel?> getActivityNotifications({
    int page = 1,
    int limit = 10,
    bool? markAsRead,
  }) async {
    try {
      final data = {
        'page': page,
        'limit': limit,
        if (markAsRead != null) 'mark_as_read': markAsRead,
      };
      final request = await _api.post(
        Endpoint.GET_ACTIVITY_NOTIFICATIONS,
        data: data,
      );
      final response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      final ResponseNotificationsModel notifications =
          ResponseNotificationsModel().fromJson(
            response.data as Map<String, dynamic>,
          );
      return notifications;
    } catch (e) {
      debugPrint("InboxRepositoryImpl ERROR in fetchNotifications: $e");
      return null;
    }
  }

  @override
  Future<ResponseMessageRequestsModel?> getMessageRequests({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final request = await _api.get(
        Endpoint.GET_MESSAGE_REQUESTS,
        parameters: {'page': page, 'limit': limit, 'status': 'pending'},
      );
      final response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      return ResponseMessageRequestsModel().fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint("InboxRepositoryImpl ERROR in getMessageRequests: $e");
      return null;
    }
  }

  @override
  Future<bool> acceptMessageRequest({required String conversationId}) async {
    try {
      final request = await _api.post(
        Endpoint.ACCEPT_MESSAGE_REQUEST,
        data: {'conversation_id': conversationId},
      );
      final response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      return response.success == true;
    } catch (e) {
      debugPrint("InboxRepositoryImpl ERROR in acceptMessageRequest: $e");
      return false;
    }
  }

  @override
  Future<bool> declineMessageRequest({required String conversationId}) async {
    try {
      final request = await _api.post(
        Endpoint.DECLINE_MESSAGE_REQUEST,
        data: {'conversation_id': conversationId},
      );
      final response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      return response.success == true;
    } catch (e) {
      debugPrint("InboxRepositoryImpl ERROR in declineMessageRequest: $e");
      return false;
    }
  }
}

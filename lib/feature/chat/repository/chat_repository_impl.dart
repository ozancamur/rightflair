import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/chat/model/chat_messages.dart';
import 'package:rightflair/feature/chat/model/chat_request.dart';
import 'package:rightflair/feature/chat/model/send_message_request.dart';
import 'package:rightflair/feature/chat/model/send_message_response.dart';
import 'package:rightflair/core/base/model/response.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiService _api;
  ChatRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<ChatMessagesModel?> fetchMessages({
    required ChatRequestModel request,
  }) async {
    try {
      final response = await _api.post(
        Endpoint.GET_CONVERSATION_MESSAGES,
        data: request.toJson(),
      );
      final result = ResponseModel().fromJson(
        response?.data as Map<String, dynamic>,
      );
      final messages = ChatMessagesModel().fromJson(
        result.data as Map<String, dynamic>,
      );
      return messages;
    } catch (e) {
      debugPrint("ChatRepositoryImpl ERROR in fetchMessages: $e");
      return null;
    }
  }

  @override
  Future<SendMessageResponseModel?> sendMessage({
    required SendMessageRequestModel request,
  }) async {
    try {
      final response = await _api.post(
        Endpoint.SEND_MESSAGE_TO_CONVERSATION,
        data: request.toJson(),
      );
      final result = ResponseModel().fromJson(
        response?.data as Map<String, dynamic>,
      );

      if (result.success == true && result.data != null) {
        return SendMessageResponseModel().fromJson(
          result.data as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      debugPrint("ChatRepositoryImpl ERROR in sendMessage: $e");
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/chat/model/chat_messages.dart';
import 'package:rightflair/feature/chat/model/chat_request.dart';
import 'package:rightflair/feature/chat/model/send_message_request.dart';
import 'package:rightflair/feature/chat/model/send_message_response.dart';
import 'package:rightflair/core/base/model/response.dart';
import 'package:rightflair/feature/post/create_post/model/post.dart';
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
        Endpoint.SEND_MESSAGE,
        data: request.toJson(),
      );

      if (response?.data == null) return null;

      final result = ResponseModel().fromJson(
        response!.data as Map<String, dynamic>,
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

  @override
  Future<PostModel?> getPostById({required String postId}) async {
    try {
      final request = await _api.get(
        Endpoint.GET_POST,
        parameters: {'post_id': postId},
      );
      final ResponseModel response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      final PostModel post = PostModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return post;
    } catch (e) {
      debugPrint("ChatRepositoryImpl ERROR in getPostById: $e");
      return null;
    }
  }
}

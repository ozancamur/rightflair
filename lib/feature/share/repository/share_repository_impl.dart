import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';
import 'package:rightflair/core/constants/enums/message_type.dart';
import 'package:rightflair/core/constants/enums/report_reason.dart';
import 'package:rightflair/feature/main/profile/model/pagination.dart';

import 'package:rightflair/feature/share/model/search_response.dart';

import '../../../core/base/model/response.dart';
import '../../../core/services/api.dart';
import 'share_repository.dart';

class ShareRepositoryImpl extends ShareRepository {
  final ApiService _api;
  ShareRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<void> reportPost({
    required String pId,
    required ReportReason reason,
  }) async {
    try {
      await _api.post(
        Endpoint.REPORT_POST,
        data: {'post_id': pId, 'reason': reason.value},
      );
    } catch (e) {
      debugPrint("ShareRepositoryImpl ERROR in reportPost: $e");
    }
  }

  @override
  Future<void> reportUser({
    required String reportedId,
    required ReportReason reason,
    String? description,
  }) async {
    try {
      await _api.post(
        Endpoint.REPORT_USER,
        data: {
          'reported_id': reportedId,
          'reason': reason.value,
          if (description != null) 'description': description,
        },
      );
    } catch (e) {
      debugPrint("ShareRepositoryImpl ERROR in reportUser: $e");
    }
  }

  @override
  Future<SearchReponseModel?> searchUsers({
    required String query,
    required PaginationModel pagination,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.SEARCH_USER,
        data: {
          'query': query,
          'page': pagination.page,
          'limit': pagination.limit,
        },
      );
      final ResponseModel response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      final SearchReponseModel data = SearchReponseModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ShareRepositoryImpl ERROR in searchUsers: $e");
      return null;
    }
  }

  @override
  Future<bool> shareProfile({
    required String recipientId,
    required String referencedUserId,
  }) async {
    if (recipientId.isEmpty || referencedUserId.isEmpty) return false;
    try {
      final response = await _api.post(
        Endpoint.SEND_MESSAGE,
        data: {
          'recipient_id': recipientId,
          'message_type': MessageType.profile_share.name,
          'referenced_user_id': referencedUserId,
        },
      );

      if (response?.data == null) return false;

      final result = ResponseModel().fromJson(
        response!.data as Map<String, dynamic>,
      );
      return result.success == true;
    } catch (e) {
      debugPrint("ShareRepositoryImpl ERROR in shareProfile: $e");
      return false;
    }
  }

  @override
  Future<bool> sharePost({
    required String recipientId,
    required String referencedPostId,
    String? content,
  }) async {
    if (recipientId.isEmpty || referencedPostId.isEmpty) return false;
    try {
      final response = await _api.post(
        Endpoint.SEND_MESSAGE,
        data: {
          'recipient_id': recipientId,
          'message_type': MessageType.post_share.name,
          'referenced_post_id': referencedPostId,
        },
      );

      if (response?.data == null) return false;

      final result = ResponseModel().fromJson(
        response!.data as Map<String, dynamic>,
      );
      return result.success == true;
    } catch (e) {
      debugPrint("ShareRepositoryImpl ERROR in sharePost: $e");
      return false;
    }
  }
}

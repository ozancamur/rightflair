import 'package:flutter/material.dart';
import 'package:rightflair/feature/post/create_post/model/mention_user.dart';

import '../../../../core/base/model/response.dart';
import '../../../../core/constants/enums/endpoint.dart';
import '../../../../core/services/api.dart';
import '../model/create_post.dart';
import 'create_post_repository.dart';

class CreatePostRepositoryImpl implements CreatePostRepository {
  final ApiService _api;
  CreatePostRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<bool> createPost({required CreatePostModel post}) async {
    try {
      final request = await _api.post(
        Endpoint.CREATE_POST,
        data: post.toJson(),
      );
      if (request == null) return false;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return response.success == true;
    } catch (e) {
      debugPrint("CreatePostRepositoryImpl ERROR in createPost :> $e");
      return false;
    }
  }

  @override
  Future<bool> createDraft({required CreatePostModel post}) async {
    try {
      final request = await _api.post(
        Endpoint.CREATE_DRAFT,
        data: post.toJson(),
      );
      if (request == null) return false;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return response.success == true;
    } catch (e) {
      debugPrint("CreatePostRepositoryImpl ERROR in createPost :> $e");
      return false;
    }
  }

  @override
  Future<List<MentionUserModel>?> searchUsersForMention({
    required String query,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.SEARCH_USER_FOR_MENTION,
        data: {"query": query, 'limit': 20},
      );
      if (request == null) return [];
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.success == true && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final list = data['users'] as List<dynamic>?;
        if (list != null) {
          final List<MentionUserModel> users = list
              .map(
                (e) => MentionUserModel().fromJson(e as Map<String, dynamic>),
              )
              .toList();
          return users;
        }
        return [];
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(
        "CreatePostRepositoryImpl ERROR in searchUsersForMention :> $e",
      );
      return [];
    }
  }
}

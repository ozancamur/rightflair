import 'package:flutter/material.dart';
import 'package:rightflair/core/services/api.dart';

import '../../../core/base/model/response.dart';
import '../../../core/constants/enums/endpoint.dart';
import '../../notifications/new_followers/model/suggested_user.dart';
import 'find_friends_repository.dart';

class FindFriendsRepositoryImpl extends FindFriendsRepository {
  final ApiService _api;
  FindFriendsRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<SuggestedUserModel?> getSuggestedUsers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_SUGGESTED_USERS,
        data: {'page': page, 'limit': limit},
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final SuggestedUserModel data = SuggestedUserModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FindFriendsRepositoryImpl ERROR in getSuggestedUsers :> $e");
      return null;
    }
  }

  @override
  Future<void> followUser({required String userId}) async {
    try {
      final request = await _api.post(
        Endpoint.FOLLOW_TO_USER,
        data: {'user_id': userId},
      );
      if (request == null) return;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return;
    } catch (e) {
      debugPrint("FindFriendsRepositoryImpl ERROR in followUser :> $e");
      return;
    }
  }

  @override
  Future<void> removeUser({required String userId}) async {
    try {
      await _api.post(
        Endpoint.GET_SUGGESTED_USERS,
        data: {'user_id': userId, 'action': 'remove'},
      );
    } catch (e) {
      debugPrint("FindFriendsRepositoryImpl ERROR in removeUser :> $e");
      return;
    }
  }

  @override
  Future<SuggestedUserModel?> searchUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> data = {'page': page, 'limit': limit};
      if (search != null && search.isNotEmpty) data['query'] = search;

      final request = await _api.post(Endpoint.SEARCH_USER, data: data);
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final SuggestedUserModel result = SuggestedUserModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return result;
    } catch (e) {
      debugPrint("FindFriendsRepositoryImpl ERROR in searchUsers :> $e");
      return null;
    }
  }
}

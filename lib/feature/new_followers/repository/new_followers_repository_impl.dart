import 'package:flutter/material.dart';

import '../../../../core/base/model/response.dart';
import '../../../../core/constants/enums/endpoint.dart';
import '../../../../core/services/api.dart';
import '../../notifications/new_followers/model/response_new_followers.dart';
import '../../notifications/new_followers/model/suggested_user.dart';
import 'new_followers_repository.dart';

class NewFollowersRepositoryImpl extends NewFollowersRepository {
  final ApiService _api;
  NewFollowersRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();
  @override
  Future<ResponseNewFollowersModel?> getNewFollowers({
    int page = 1,
    int limit = 6,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_FOLLOWER_NOTIFICATIONS,
        data: {'page': page, 'limit': limit},
      );
      final response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      final ResponseNewFollowersModel data = ResponseNewFollowersModel()
          .fromJson(response.data as Map<String, dynamic>);
      return data;
    } catch (e) {
      debugPrint("NewFollowersRepositoryImpl ERROR in fetchNewFollowers: $e");
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
      debugPrint("UserRepositoryImpl ERROR in followUser :> $e");
      return;
    }
  }

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
      debugPrint("UserRepositoryImpl ERROR in getSuggestedUsers :> $e");
      return null;
    }
  }
}

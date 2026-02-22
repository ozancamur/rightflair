import 'package:flutter/material.dart';
import 'package:rightflair/core/services/api.dart';

import '../../../core/base/model/response.dart';
import '../../../core/constants/enums/endpoint.dart';
import '../model/follow_list_request.dart';
import '../model/follow_list_response.dart';
import 'follow_repository.dart';

class FollowRepositoryImpl extends FollowRepository {
  final ApiService _api;
  FollowRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();
  
  @override
  Future<FollowListResponseModel?> getFollowersList({
    required FollowListRequestModel parameters,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_FOLLOWERS_LIST,
        data: parameters.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final FollowListResponseModel data = FollowListResponseModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FollowRepositoryImpl ERROR in getFollowersList :> $e");
      return null;
    }
  }

  @override
  Future<FollowListResponseModel?> getFollowingList({
    required FollowListRequestModel parameters,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_FOLLOWING_LIST,
        data: parameters.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final FollowListResponseModel data = FollowListResponseModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FollowRepositoryImpl ERROR in getFollowingList :> $e");
      return null;
    }
  }
}

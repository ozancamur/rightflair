import 'package:flutter/widgets.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/authentication/model/user.dart';
import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';

import '../../../../../core/base/model/response.dart';
import '../../navigation/page/profile/model/request_post.dart';
import '../../navigation/page/profile/model/response_post.dart';
import 'user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final ApiService _api;
  UserRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<UserModel?> getUser({required String userId}) async {
    try {
      final request = await _api.post(
        Endpoint.GET_USER,
        data: {'user_id': userId},
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final UserModel data = UserModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("UserRepositoryImpl ERROR in getUser :> $e");
      return null;
    }
  }

  @override
  Future<ResponsePostModel?> getUserPosts({
    required RequestPostModel parameters,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_USER_POSTS,
        parameters: parameters.toJson(),
      );
      if (request == null) return null;
      final ResponsePostModel data = ResponsePostModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return null;
      return data;
    } catch (e) {
      debugPrint("UserRepositoryImpl ERROR in getUserPosts :> $e");
      return null;
    }
  }

  @override
  Future<StyleTagsModel?> getUserStyleTags({required String userId}) async {
    try {
      final request = await _api.post(
        Endpoint.GET_USER_STYLE_TAGS,
        data: {'user_id': userId},
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return null;
      final StyleTagsModel data = StyleTagsModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("UserRepositoryImpl ERROR in getUserStyleTags :> $e");
      return null;
    }
  }

  @override
  Future<bool?> checkFollowingUser({required String userId}) async {
    try {
      final request = await _api.post(
        Endpoint.CHECK_TO_FOLLOWING_USER,
        data: {'user_id': userId},
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final data = response.data as Map<String, dynamic>;
      final bool isFollowing = data['is_following'] ?? false;
      return isFollowing;
    } catch (e) {
      debugPrint("UserRepositoryImpl ERROR in checkFollowingUser :> $e");
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> followUser({required String userId}) async {
    try {
      final request = await _api.post(
        Endpoint.FOLLOW_TO_USER,
        data: {'user_id': userId},
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      return response.data as Map<String, dynamic>;
    } catch (e) {
      debugPrint("UserRepositoryImpl ERROR in followUser :> $e");
      return null;
    }
  }
}

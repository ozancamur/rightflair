import 'package:flutter/widgets.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/authentication/model/user.dart';
import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';

import '../../../../../core/base/model/response.dart';
import 'user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final ApiService _api;
  UserRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<UserModel?> getUser({required String userId}) async {
    try {
      final request = await _api.get(
        Endpoint.GET_USER,
        data: {'user_id': userId},
      );
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
  Future<void> getUserPosts({required String userId}) async {
    try {
      final request = await _api.get(
        Endpoint.GET_USER_POSTS,
        data: {'user_id': userId},
      );
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint("UserRepositoryImpl ERROR in getUserPosts :> $e");
    }
  }

  @override
  Future<StyleTagsModel?> getUserStyleTags({required String userId}) async {
    try {
      final request = await _api.get(
        Endpoint.GET_USER_STYLE_TAGS,
        data: {'user_id': userId},
      );
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      final StyleTagsModel data = StyleTagsModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("UserRepositoryImpl ERROR in getUserStyleTags :> $e");
      return null;
    }
  }
}

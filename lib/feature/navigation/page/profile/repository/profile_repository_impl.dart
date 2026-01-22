import 'package:flutter/widgets.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/authentication/model/user.dart';

import '../../../../../core/base/model/response.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ApiService _api;
  ProfileRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<UserModel?> getUser() async {
    try {
      final request = await _api.get(Endpoint.GET_USER);
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final UserModel data = UserModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUser :> $e");
      return null;
    }
  }

  @override
  Future<void> getUserPosts() async {
    try {
      final request = await _api.get(Endpoint.GET_USER_POSTS);
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      print("GET USER POSTS ${response.data}");
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUserPosts :> $e");
    }
  }
}

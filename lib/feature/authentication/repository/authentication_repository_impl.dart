import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';
import 'package:rightflair/core/services/api.dart';

import '../model/user.dart';
import 'authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final ApiService _api;

  AuthenticationRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<UserModel?> createUser({required UserModel user}) async {
    try {
      final request = await _api.dio.post(
        Endpoint.CREATE_USER.value,
        data: user.toJson(),
      );
      final UserModel data = UserModel().fromJson(request.data['data']);
      if (request.data == null) return null;
      return data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        debugPrint("ℹ️ User already exists, proceeding with login.");
        return user;
      }
      debugPrint("❌ SupabaseDatabaseCreateService ERROR in createUser :> $e");
      return null;
    } catch (e) {
      debugPrint("❌ SupabaseDatabaseCreateService ERROR in createUser :> $e");
      return null;
    }
  }
}

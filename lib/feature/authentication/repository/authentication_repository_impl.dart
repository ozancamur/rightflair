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
      final request = await _api.post(
        Endpoint.CREATE_USER,
        data: user.toJson(),
      );
      if (request == null) return null;
      final UserModel data = UserModel().fromJson(request.data['data']);
      if (request.data == null) return null;
      return data;
    } catch (e) {
      debugPrint("❌ SupabaseDatabaseCreateService ERROR in createUser :> $e");
      return null;
    }
  }
}

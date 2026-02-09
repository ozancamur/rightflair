import 'package:flutter/material.dart';
import 'package:rightflair/core/services/api.dart';

import '../../../core/base/model/response.dart';
import '../../../core/constants/enums/endpoint.dart';
import '../model/notifications.dart';
import '../model/settings.dart';
import 'settings_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final ApiService _api;
  SettingsRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final request = await _api.get(Endpoint.GET_USER_SETTINGS);
      if(request == null) return SettingsModel().error();
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if(request.data == null) return SettingsModel().error();
      final SettingsModel settings = SettingsModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return settings;
    } catch (e) {
      debugPrint("SettingsRepositoryImpl ERROR in getUser :> $e");
      return SettingsModel().error();
    }
  }

  @override
  Future<void> updateSettings({
    required NotificationsModel notifications,
  }) async {
    try {
      await _api.post(
        Endpoint.UPDATE_USER_SETTINGS,
        data: notifications.toJson(),
      );
    } catch (e) {
      debugPrint("SettingsRepositoryImpl ERROR in updateSettings :> $e");
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await _api.post(Endpoint.DELETE_USER);
    } catch (e) {
      debugPrint("SettingsRepositoryImpl ERROR in deleteUser :> $e");
    }
  }
}

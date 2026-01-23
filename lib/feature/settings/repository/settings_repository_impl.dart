import 'package:flutter/material.dart';
import 'package:rightflair/core/services/api.dart';

import '../../../core/base/model/response.dart';
import '../../../core/constants/endpoint.dart';
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
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
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
}

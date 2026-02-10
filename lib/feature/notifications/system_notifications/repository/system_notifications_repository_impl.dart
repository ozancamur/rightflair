import 'package:flutter/material.dart';
import 'package:rightflair/feature/main/inbox/model/response_notifications.dart';

import '../../../../core/base/model/response.dart';
import '../../../../core/constants/enums/endpoint.dart';
import '../../../../core/services/api.dart';
import 'system_notifications_repository.dart';

class SystemNotificationsRepositoryImpl extends SystemNotificationsRepository {
  final ApiService _api;
  SystemNotificationsRepositoryImpl({ApiService? api})
    : _api = api ?? ApiService();

  @override
  Future<ResponseNotificationsModel?> getSystemNotifications({
    required int page,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_SYSTEM_NOTIFICATIONS,
        data: {'page': page, 'limit': 10},
      );
      final response = ResponseModel().fromJson(
        request?.data as Map<String, dynamic>,
      );
      final ResponseNotificationsModel notifications =
          ResponseNotificationsModel().fromJson(
            response.data as Map<String, dynamic>,
          );
      return notifications;
    } catch (e) {
      debugPrint(
        "SystemNotificationsRepositoryImpl ERROR in fetchNotifications: $e",
      );
      return null;
    }
  }
}

import 'package:flutter/widgets.dart';
import 'package:rightflair/core/base/model/response.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/core/services/api.dart';

import '../model/analytics.dart';
import '../model/date_range.dart';
import 'analytics_repository.dart';

class AnalyticsRepositoryImpl extends AnalyticsRepository {
  final ApiService _api;

  AnalyticsRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<AnalyticsModel?> getAnalytics({
    DateRange dateRange = DateRange.allTime,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_ANALYSIS,
        data: {'date_range': dateRange.value},
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final AnalyticsModel data = AnalyticsModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("AnalyticsRepository ERROR in getAnalytics :> $e");
      return null;
    }
  }
}

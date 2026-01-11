import '../model/analytics_model.dart';

class AnalyticsRepository {
  Future<AnalyticsModel> getAnalytics() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    return AnalyticsModel.mock;
  }
}

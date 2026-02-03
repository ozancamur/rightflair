import '../model/analytics.dart';
import '../model/date_range.dart';

abstract class AnalyticsRepository {
  Future<AnalyticsModel?> getAnalytics({
    DateRange dateRange = DateRange.last7Days,
  });
}

import '../model/analytics.dart';
import '../../../../../core/constants/enums/date_range.dart';

abstract class AnalyticsRepository {
  Future<AnalyticsModel?> getAnalytics({
    DateRange dateRange = DateRange.last7Days,
  });
}

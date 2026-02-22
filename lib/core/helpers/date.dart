import 'package:easy_localization/easy_localization.dart';

import '../../feature/main/analytics/model/engagement_chart.dart';
import '../constants/enums/date_range.dart';
import '../constants/string.dart';

class DateHelper {
  DateHelper._();

  static String timeAgo(DateTime? date) {
    final now = DateTime.now();
    final difference = now.difference(date ?? DateTime.now());

    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  static String getLocalizedDayLabel(String? dayLabel) {
    if (dayLabel == null) return '';
    switch (dayLabel.toLowerCase()) {
      case 'mon':
        return AppStrings.DAY_MONDAY.tr();
      case 'tue':
        return AppStrings.DAY_TUESDAY.tr();
      case 'wed':
        return AppStrings.DAY_WEDNESDAY.tr();
      case 'thu':
        return AppStrings.DAY_THURSDAY.tr();
      case 'fri':
        return AppStrings.DAY_FRIDAY.tr();
      case 'sat':
        return AppStrings.DAY_SATURDAY.tr();
      case 'sun':
        return AppStrings.DAY_SUNDAY.tr();
      default:
        return dayLabel;
    }
  }

  static List<String> getLabels({
    required List<EngagementChartModel>? data,
    required DateRange dateRange,
  }) {
    if (data == null || data.isEmpty) return [];

    switch (dateRange) {
      case DateRange.last7Days:
        return data
            .map((e) => DateHelper.getLocalizedDayLabel(e.dayLabel))
            .toList();

      case DateRange.last30Days:
        return _getLast30DaysLabels(data: data);

      case DateRange.last6Months:
        return _getMonthLabels(data: data);

      case DateRange.last1Year:
        return _getMonthLabels(data: data);
    }
  }

  static List<String> _getMonthLabels({
    required List<EngagementChartModel>? data,
  }) {
    final monthSet = <int>{};
    final labels = <String>[];

    for (final item in data ?? []) {
      if (item.date != null) {
        try {
          final date = DateTime.parse(item.date!);
          if (!monthSet.contains(date.month)) {
            monthSet.add(date.month);
            labels.add(_getLocalizedMonth(date.month));
          }
        } catch (_) {}
      }
    }

    return labels;
  }

  static List<String> _getLast30DaysLabels({
    required List<EngagementChartModel>? data,
  }) {
    final labels = <String>[];
    final step = (data?.length ?? 0 / 6).ceil();

    for (int i = 0; i < (data?.length ?? 0); i += step) {
      final item = data?[i];
      if (item?.date != null) {
        try {
          final date = DateTime.parse(item!.date!);
          labels.add(date.day.toString().padLeft(2, '0'));
        } catch (_) {
          labels.add('');
        }
      }
    }

    // Add the last date as well
    if (data != null && data.isNotEmpty) {
      final lastItem = data.last;
      if (lastItem.date != null) {
        try {
          final date = DateTime.parse(lastItem.date!);
          final lastLabel = date.day.toString().padLeft(2, '0');
          if (labels.isEmpty || labels.last != lastLabel) {
            labels.add(lastLabel);
          }
        } catch (_) {}
      }
    }

    return labels;
  }

  static String _getLocalizedMonth(int month) {
    switch (month) {
      case 1:
        return AppStrings.MONTH_JANUARY.tr();
      case 2:
        return AppStrings.MONTH_FEBRUARY.tr();
      case 3:
        return AppStrings.MONTH_MARCH.tr();
      case 4:
        return AppStrings.MONTH_APRIL.tr();
      case 5:
        return AppStrings.MONTH_MAY.tr();
      case 6:
        return AppStrings.MONTH_JUNE.tr();
      case 7:
        return AppStrings.MONTH_JULY.tr();
      case 8:
        return AppStrings.MONTH_AUGUST.tr();
      case 9:
        return AppStrings.MONTH_SEPTEMBER.tr();
      case 10:
        return AppStrings.MONTH_OCTOBER.tr();
      case 11:
        return AppStrings.MONTH_NOVEMBER.tr();
      case 12:
        return AppStrings.MONTH_DECEMBER.tr();
      default:
        return '';
    }
  }
}

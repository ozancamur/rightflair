import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context.dart';
import '../cubit/analytics_cubit.dart';
import '../model/date_range.dart';

class DateRangeButton extends StatelessWidget {
  final DateRange selectedRange;

  const DateRangeButton({super.key, required this.selectedRange});

  String _getDateRangeLabel(DateRange range) {
    switch (range) {
      case DateRange.last7Days:
        return 'analytics.last7Days'.tr();
      case DateRange.last30Days:
        return 'analytics.last30Days'.tr();
      case DateRange.last6Months:
        return 'analytics.last6Months'.tr();
      case DateRange.last1Year:
        return 'analytics.last1Year'.tr();
      case DateRange.allTime:
        return 'analytics.allTime'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DateRange>(
      onSelected: (DateRange range) {
        context.read<AnalyticsCubit>().changeDateRange(range);
      },
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (BuildContext context) => DateRange.values.map((range) {
        return PopupMenuItem<DateRange>(
          value: range,
          child: Row(
            children: [
              if (selectedRange == range)
                Icon(Icons.check, size: 18, color: context.colors.primary)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(
                _getDateRangeLabel(range),
                style: TextStyle(
                  color: context.colors.primary,
                  fontWeight: selectedRange == range
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getDateRangeLabel(selectedRange),
              style: TextStyle(
                color: context.colors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

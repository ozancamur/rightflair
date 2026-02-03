import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../core/constants/color/color.dart';
import '../model/date_range.dart';
import '../model/engagement_chart.dart';
import 'chart_painter.dart';

class AnalyticsEngagementChartWidget extends StatefulWidget {
  final List<EngagementChartModel> data;
  final DateRange dateRange;

  const AnalyticsEngagementChartWidget({
    super.key,
    required this.data,
    required this.dateRange,
  });

  @override
  State<AnalyticsEngagementChartWidget> createState() =>
      _AnalyticsEngagementChartWidgetState();
}

class _AnalyticsEngagementChartWidgetState
    extends State<AnalyticsEngagementChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant AnalyticsEngagementChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dateRange != widget.dateRange ||
        oldWidget.data != widget.data) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<double> get _chartData =>
      widget.data.map((e) => e.value ?? 0.0).toList();

  // dayLabel'ı localized string'e çevir
  String _getLocalizedDayLabel(String? dayLabel) {
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

  // Ay numarasını localized string'e çevir
  String _getLocalizedMonth(int month) {
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

  List<String> _getLabels() {
    if (widget.data.isEmpty) return [];

    switch (widget.dateRange) {
      case DateRange.last7Days:
        return widget.data
            .map((e) => _getLocalizedDayLabel(e.dayLabel))
            .toList();

      case DateRange.last30Days:
        return _getLast30DaysLabels();

      case DateRange.last6Months:
        return _getMonthLabels();

      case DateRange.last1Year:
        return _getMonthLabels();
    }
  }

  List<String> _getLast30DaysLabels() {
    final labels = <String>[];
    final step = (widget.data.length / 6).ceil();

    for (int i = 0; i < widget.data.length; i += step) {
      final item = widget.data[i];
      if (item.date != null) {
        try {
          final date = DateTime.parse(item.date!);
          labels.add(date.day.toString().padLeft(2, '0'));
        } catch (_) {
          labels.add('');
        }
      }
    }

    // Add the last date as well
    if (widget.data.isNotEmpty) {
      final lastItem = widget.data.last;
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

  List<String> _getMonthLabels() {
    final monthSet = <int>{};
    final labels = <String>[];

    for (final item in widget.data) {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _animation.value)),
            child: Container(
              padding: EdgeInsets.all(context.width * 0.05),
              margin: EdgeInsets.symmetric(horizontal: context.width * 0.015),
              decoration: BoxDecoration(
                color: context.colors.onBackground,
                borderRadius: BorderRadius.circular(context.width * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.SHADOW,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _title(context),
                  SizedBox(height: context.height * 0.02),
                  _graph(context),
                  SizedBox(height: context.height * 0.01),
                  _labelsRow(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextComponent(
          text: AppStrings.ANALYTICS_ENGAGEMENT_OVERVIEW,
          size: [context.width * 0.035],
          weight: FontWeight.w600,
          color: context.colors.primary,
        ),
      ],
    );
  }

  Widget _graph(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: context.height * 0.2,
          width: double.infinity,
          margin: EdgeInsets.all(context.width * 0.025),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: context.colors.primaryFixedDim),
              bottom: BorderSide(color: context.colors.primaryFixedDim),
            ),
          ),
          child: CustomPaint(
            painter: ChartPainter(
              data: _chartData,
              lineColor: context.colors.scrim,
              fillColor: context.colors.scrim.withOpacity(0.1),
              gridColor: context.colors.primaryFixedDim,
              animationValue: _animation.value,
            ),
          ),
        );
      },
    );
  }

  Widget _labelsRow(BuildContext context) {
    final labels = _getLabels();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Row(
        key: ValueKey(widget.dateRange),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: labels
            .map(
              (label) => Expanded(
                child: Center(
                  child: TextComponent(
                    text: label,
                    size: [context.width * 0.025],
                    color: context.colors.tertiary,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

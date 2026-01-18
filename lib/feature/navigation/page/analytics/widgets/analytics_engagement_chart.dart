import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../core/constants/color/color.dart';
import 'chart_painter.dart';

class AnalyticsEngagementChartWidget extends StatefulWidget {
  final List<double> data;

  const AnalyticsEngagementChartWidget({super.key, required this.data});

  @override
  State<AnalyticsEngagementChartWidget> createState() =>
      _AnalyticsEngagementChartWidgetState();
}

class _AnalyticsEngagementChartWidgetState
    extends State<AnalyticsEngagementChartWidget> {
  String _selectedPeriod = AppStrings.ANALYTICS_LAST_7_DAYS;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _days(context),
        ],
      ),
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
        _last(context),
      ],
    );
  }

  Widget _last(BuildContext context) {
    return PopupMenuButton<String>(
      color: context.colors.secondary,
      onSelected: (String value) {
        setState(() {
          _selectedPeriod = value;
        });
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: AppStrings.ANALYTICS_LAST_7_DAYS,
          child: Text(
            AppStrings.ANALYTICS_LAST_7_DAYS.tr(),
            style: TextStyle(color: context.colors.primary),
          ),
        ),
        PopupMenuItem<String>(
          value: AppStrings.ANALYTICS_LAST_30_DAYS,
          child: Text(
            AppStrings.ANALYTICS_LAST_30_DAYS.tr(),
            style: TextStyle(color: context.colors.primary),
          ),
        ),
        PopupMenuItem<String>(
          value: AppStrings.ANALYTICS_LAST_6_MONTHS,
          child: Text(
            AppStrings.ANALYTICS_LAST_6_MONTHS.tr(),
            style: TextStyle(color: context.colors.primary),
          ),
        ),
      ],
      child: Row(
        children: [
          TextComponent(
            text: _selectedPeriod.tr(),
            tr: false,
            size: [context.width * 0.03],
            color: context.colors.tertiary,
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: context.colors.tertiary,
            size: context.width * 0.04,
          ),
        ],
      ),
    );
  }

  Container _graph(BuildContext context) {
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
          data: widget.data,
          lineColor: context.colors.scrim,
          fillColor: context.colors.scrim.withOpacity(0.1),
          gridColor: context.colors.primaryFixedDim,
        ),
      ),
    );
  }

  Row _days(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          [
                AppStrings.DAY_MONDAY,
                AppStrings.DAY_TUESDAY,
                AppStrings.DAY_WEDNESDAY,
                AppStrings.DAY_THURSDAY,
                AppStrings.DAY_FRIDAY,
                AppStrings.DAY_SATURDAY,
                AppStrings.DAY_SUNDAY,
              ]
              .map(
                (day) => TextComponent(
                  text: day,
                  size: [context.width * 0.025],
                  color: context.colors.tertiary,
                ),
              )
              .toList(),
    );
  }
}

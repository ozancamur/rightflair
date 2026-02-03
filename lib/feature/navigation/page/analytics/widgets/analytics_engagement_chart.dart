import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../core/constants/color/color.dart';
import 'chart_painter.dart';

class AnalyticsEngagementChartWidget extends StatelessWidget {
  final List<double> data;

  const AnalyticsEngagementChartWidget({super.key, required this.data});

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
      ],
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
          data: data,
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

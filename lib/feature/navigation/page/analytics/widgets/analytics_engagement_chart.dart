import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import 'chart_painter.dart';

class AnalyticsEngagementChartWidget extends StatelessWidget {
  final List<double> data;

  const AnalyticsEngagementChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.05),
      decoration: BoxDecoration(
        color: context.colors.shadow,
        borderRadius: BorderRadius.circular(context.width * 0.05),
      ),
      child: Column(
        spacing: context.height * 0.02,
        children: [
          _titleAndLast(context),
          SizedBox(
            height: context.height * 0.2,
            width: double.infinity,
            child: CustomPaint(
              painter: ChartPainter(
                data: data,
                lineColor: context.colors.scrim,
                fillColor: context.colors.scrim.withOpacity(0.1),
                gridColor: context.colors.primaryFixedDim,
              ),
            ),
          ),
          _days(context),
        ],
      ),
    );
  }

  Row _titleAndLast(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextComponent(
          text: AppStrings.ANALYTICS_ENGAGEMENT_OVERVIEW,
          size: [context.width * 0.035],
          weight: FontWeight.w600,
        ),
        Row(
          children: [
            TextComponent(
              text: AppStrings.ANALYTICS_LAST_7_DAYS,
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
      ],
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

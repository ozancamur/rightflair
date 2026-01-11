import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/dark_color.dart';
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
        color: AppDarkColors.INACTIVE,
        borderRadius: BorderRadius.circular(context.width * 0.05),
      ),
      child: Column(
        children: [
          Row(
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
                    color: AppDarkColors.GREY,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppDarkColors.GREY,
                    size: context.width * 0.04,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: context.height * 0.02),
          SizedBox(
            height: context.height * 0.2,
            width: double.infinity,
            child: CustomPaint(
              painter: ChartPainter(
                data: data,
                lineColor: AppDarkColors
                    .ORANGE, // Using ORANGE as strictly requested from palette
                fillColor: AppDarkColors.ORANGE.withOpacity(0.1),
                gridColor: AppDarkColors.WHITE16,
              ),
            ),
          ),
          SizedBox(height: context.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                .map(
                  (day) => TextComponent(
                    text: day,
                    size: [context.width * 0.025],
                    color: AppDarkColors.GREY,
                    tr: false,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

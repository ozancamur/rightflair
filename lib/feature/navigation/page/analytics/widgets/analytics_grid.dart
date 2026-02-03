import 'package:flutter/material.dart';

import '../../../../../core/constants/icons.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';
import '../model/analytics.dart';
import 'analytics_stat_card.dart';

class AnalyticsGridWidget extends StatelessWidget {
  final AnalyticsModel? data;
  const AnalyticsGridWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.015),
      child: Column(
        spacing: context.height * 0.02,
        children: [
          Row(
            spacing: context.width * 0.04,
            children: [
              Expanded(
                child: AnalyticsStatCardWidget(
                  title: AppStrings.ANALYTICS_SHARE,
                  icon: AppIcons.ANALYTIC_VIEW,
                  value: "${data?.shares?.value ?? '0'}",
                  growth: data?.shares?.changePercentage ?? 0,
                ),
              ),
              Expanded(
                child: AnalyticsStatCardWidget(
                  title: AppStrings.ANALYTICS_LIKES,
                  icon: AppIcons.ANALYTIC_LIKE,
                  value: "${data?.likes?.value ?? '0'}",
                  growth: data?.likes?.changePercentage ?? 0,
                ),
              ),
            ],
          ),

          Row(
            spacing: context.width * 0.04,
            children: [
              Expanded(
                child: AnalyticsStatCardWidget(
                  title: AppStrings.ANALYTICS_FOLLOWERS,
                  icon: AppIcons.ANALYTIC_FOLLOWER,
                  value: "${data?.followers?.value ?? '0'}",
                  growth: data?.followers?.changePercentage ?? 0,
                ),
              ),
              Expanded(
                child: AnalyticsStatCardWidget(
                  title: AppStrings.ANALYTICS_SAVES,
                  icon: AppIcons.ANALYTIC_SAVES,
                  value: "${data?.saves?.value ?? '0'}",
                  growth: data?.saves?.changePercentage ?? 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

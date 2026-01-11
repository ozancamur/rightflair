import 'package:flutter/material.dart';

import '../../../../../core/constants/icons.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';
import '../model/analytics_model.dart';
import 'analytics_stat_card.dart';

class AnalyticsGridWidget extends StatelessWidget {
  final AnalyticsModel data;
  const AnalyticsGridWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AnalyticsStatCardWidget(
                title: AppStrings.ANALYTICS_SHARE,
                icon: AppIcons.ANALYTIC_VIEW,
                value: data.shareCount,
                growth: data.shareGrowth,
              ),
            ),
            SizedBox(width: context.width * 0.04),
            Expanded(
              child: AnalyticsStatCardWidget(
                title: AppStrings.ANALYTICS_LIKES,
                icon: AppIcons.ANALYTIC_LIKE,
                value: data.likeCount,
                growth: data.likeGrowth,
              ),
            ),
          ],
        ),
        SizedBox(height: context.height * 0.02),
        Row(
          children: [
            Expanded(
              child: AnalyticsStatCardWidget(
                title: AppStrings.ANALYTICS_FOLLOWERS,
                icon: AppIcons.ANALYTIC_FOLLOWER,
                value: data.followerCount,
                growth: data.followerGrowth,
              ),
            ),
            SizedBox(width: context.width * 0.04),
            Expanded(
              child: AnalyticsStatCardWidget(
                title: AppStrings.ANALYTICS_SAVES,
                icon: AppIcons.ANALYTIC_SAVES,
                value: data.saveCount,
                growth: data.saveGrowth,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

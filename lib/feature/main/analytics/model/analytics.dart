
import 'package:rightflair/feature/main/analytics/model/engagement_chart.dart';

import '../../../../core/base/model/base.dart';
import 'actions_percentage.dart';

class AnalyticsModel extends BaseModel<AnalyticsModel> {
  String? dateRange;
  String? periodStart;
  String? periodEnd;
  ActionsPercentageModel? shares;
  ActionsPercentageModel? likes;
  ActionsPercentageModel? followers;
  ActionsPercentageModel? saves;
  List<EngagementChartModel>? engagementChart;

  AnalyticsModel({
    this.dateRange,
    this.periodStart,
    this.periodEnd,
    this.shares,
    this.likes,
    this.followers,
    this.saves,
    this.engagementChart,
  });

  @override
  AnalyticsModel copyWith({
    String? dateRange,
    String? periodStart,
    String? periodEnd,
    ActionsPercentageModel? shares,
    ActionsPercentageModel? likes,
    ActionsPercentageModel? followers,
    ActionsPercentageModel? saves,
    List<EngagementChartModel>? engagementChart,
  }) {
    return AnalyticsModel(
      dateRange: dateRange ?? this.dateRange,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      shares: shares ?? this.shares,
      likes: likes ?? this.likes,
      followers: followers ?? this.followers,
      saves: saves ?? this.saves,
      engagementChart: engagementChart ?? this.engagementChart,
    );
  }

  @override
  AnalyticsModel fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      dateRange: json['date_range'] as String?,
      periodStart: json['period_start'] as String?,
      periodEnd: json['period_end'] as String?,
      shares: json['shares'] != null
          ? ActionsPercentageModel().fromJson(json['shares'])
          : null,
      likes: json['likes'] != null
          ? ActionsPercentageModel().fromJson(json['likes'])
          : null,
      followers: json['followers'] != null
          ? ActionsPercentageModel().fromJson(json['followers'])
          : null,
      saves: json['saves'] != null
          ? ActionsPercentageModel().fromJson(json['saves'])
          : null,
      engagementChart: (json['engagement_chart'] as List<dynamic>?)
          ?.map(
            (e) => EngagementChartModel().fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'date_range': dateRange,
      'period_start': periodStart,
      'period_end': periodEnd,
      'shares': shares?.toJson(),
      'likes': likes?.toJson(),
      'followers': followers?.toJson(),
      'saves': saves?.toJson(),
      'engagement_chart': engagementChart?.map((e) => e.toJson()).toList(),
    };
  }
}

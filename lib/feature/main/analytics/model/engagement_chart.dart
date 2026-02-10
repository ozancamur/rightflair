import '../../../../core/base/model/base.dart';

class EngagementChartModel extends BaseModel<EngagementChartModel> {
  String? date;
  String? dayLabel;
  double? value;

  EngagementChartModel({this.date, this.dayLabel, this.value});

  @override
  EngagementChartModel copyWith({
    String? date,
    String? dayLabel,
    double? value,
  }) {
    return EngagementChartModel(
      date: date ?? this.date,
      dayLabel: dayLabel ?? this.dayLabel,
      value: value ?? this.value,
    );
  }

  @override
  EngagementChartModel fromJson(Map<String, dynamic> json) {
    return EngagementChartModel(
      date: json['date'] as String?,
      dayLabel: json['day_label'] as String?,
      value: json['value'] as double?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'date': date, 'day_label': dayLabel, 'value': value};
  }
}

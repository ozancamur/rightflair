import 'package:rightflair/core/base/model/base.dart';

class ActionsPercentageModel extends BaseModel<ActionsPercentageModel> {
  double? value;
  int? changePercentage;

  ActionsPercentageModel({this.value, this.changePercentage});

  @override
  ActionsPercentageModel copyWith({double? value, int? changePercentage}) {
    return ActionsPercentageModel(
      value: value ?? this.value,
      changePercentage: changePercentage ?? this.changePercentage,
    );
  }

  @override
  ActionsPercentageModel fromJson(Map<String, dynamic> json) {
    return ActionsPercentageModel(
      value: json['value'] as double?,
      changePercentage: json['change_percentage'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'value': value, 'change_percentage': changePercentage};
  }
}

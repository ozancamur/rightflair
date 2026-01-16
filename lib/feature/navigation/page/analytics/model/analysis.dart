import '../../../../../core/base/base_modeld.dart';

class AnalysisModel extends BaseModel {
  String? id;
  String? name;
  String? value;

  AnalysisModel({this.id, this.name, this.value});

  @override
  copyWith({String? id, String? name, String? value}) {
    return AnalysisModel(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'value': value};
  }
}

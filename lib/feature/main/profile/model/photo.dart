import '../../../../core/base/model/base.dart';

class PhotoModel extends BaseModel {
  String? url;
  int? viewed;

  PhotoModel({this.url, this.viewed});

  @override
  PhotoModel copyWith({String? url, int? viewed}) {
    return PhotoModel(url: url ?? this.url, viewed: viewed ?? this.viewed);
  }

  @override
  PhotoModel fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      url: json['url'] as String?,
      viewed: json['viewed'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'url': url, 'viewed': viewed};
  }
}

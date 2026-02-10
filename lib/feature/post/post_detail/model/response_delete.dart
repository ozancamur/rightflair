import '../../../../core/base/model/base.dart';

class ResponseDeleteModel extends BaseModel<ResponseDeleteModel> {
  String? postId;
  String? deletedAt;
  ResponseDeleteModel({this.postId, this.deletedAt});

  @override
  ResponseDeleteModel copyWith({String? postId, String? deletedAt}) {
    return ResponseDeleteModel(
      postId: postId ?? this.postId,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  ResponseDeleteModel fromJson(Map<String, dynamic> json) {
    return ResponseDeleteModel(
      postId: json['post_id'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'post_id': postId, 'deleted_at': deletedAt};
  }
}

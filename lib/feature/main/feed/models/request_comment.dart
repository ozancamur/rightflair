import '../../../../core/base/model/base.dart';

class RequestCommentModel extends BaseModel<RequestCommentModel> {
  String? postId;
  String? content;
  String? parentId;

  RequestCommentModel({this.postId, this.content, this.parentId});

  @override
  RequestCommentModel copyWith({
    String? postId,
    String? content,
    String? parentId,
  }) {
    return RequestCommentModel(
      postId: postId ?? this.postId,
      content: content ?? this.content,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  RequestCommentModel fromJson(Map<String, dynamic> json) {
    return RequestCommentModel(
      postId: json['post_id'] as String?,
      content: json['content'] as String?,
      parentId: json['parent_id'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'content': content,
      'parent_id': parentId,
    };
  }
}

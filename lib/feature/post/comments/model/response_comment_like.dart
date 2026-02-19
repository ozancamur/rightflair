import '../../../../core/base/model/base.dart';

class ResponseCommentLikeModel extends BaseModel<ResponseCommentLikeModel> {
  String? commentId;
  bool? isLiked;
  int? likeCount;

  ResponseCommentLikeModel({this.commentId, this.isLiked, this.likeCount});

  @override
  ResponseCommentLikeModel copyWith({
    String? commentId,
    bool? isLiked,
    int? likeCount,
  }) {
    return ResponseCommentLikeModel(
      commentId: commentId ?? this.commentId,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
    );
  }

  @override
  ResponseCommentLikeModel fromJson(Map<String, dynamic> json) {
    return ResponseCommentLikeModel(
      commentId: json['comment_id'] as String?,
      isLiked: json['is_liked'] as bool?,
      likeCount: json['like_count'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'is_liked': isLiked,
      'like_count': likeCount,
    };
  }
}

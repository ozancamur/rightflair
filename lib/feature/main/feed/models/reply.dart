import '../../../../core/base/model/base.dart';
import 'comment_user.dart';

class ReplyModel extends BaseModel<ReplyModel> {
  String? id;
  String? content;
  int? likesCount;
  DateTime? createdAt;
  CommentUserModel? user;
  bool? isLiked;

  ReplyModel({
    this.id,
    this.content,
    this.likesCount,
    this.createdAt,
    this.user,
    this.isLiked,
  });

  @override
  ReplyModel copyWith({
    String? id,
    String? content,
    int? likesCount,
    DateTime? createdAt,
    CommentUserModel? user,
    bool? isLiked,
  }) {
    return ReplyModel(
      id: id ?? this.id,
      content: content ?? this.content,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  ReplyModel fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'] as String?,
      content: json['content'] as String?,
      likesCount: json['likes_count'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      user: json['user'] != null
          ? CommentUserModel().fromJson(json['user'] as Map<String, dynamic>)
          : null,
      isLiked: json['is_liked'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'likes_count': likesCount,
      'created_at': createdAt?.toIso8601String(),
      'user': user?.toJson(),
      'is_liked': isLiked,
    };
  }
}

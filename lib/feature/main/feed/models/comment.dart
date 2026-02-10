import '../../../../core/base/model/base.dart';
import 'comment_user.dart';
import 'reply.dart';

class CommentModel extends BaseModel<CommentModel> {
  String? id;
  String? content;
  int? likesCount;
  DateTime? createdAt;
  CommentUserModel? user;
  bool? isLiked;
  int? repliesCount;
  List<ReplyModel>? replies;

  CommentModel({
    this.id,
    this.content,
    this.likesCount,
    this.createdAt,
    this.user,
    this.isLiked,
    this.repliesCount,
    this.replies,
  });

  @override
  CommentModel copyWith({
    String? id,
    String? content,
    int? likesCount,
    DateTime? createdAt,
    CommentUserModel? user,
    bool? isLiked,
    int? repliesCount,
    List<ReplyModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      isLiked: isLiked ?? this.isLiked,
      repliesCount: repliesCount ?? this.repliesCount,
      replies: replies ?? this.replies,
    );
  }

  @override
  CommentModel fromJson(Map<String, dynamic> json) {
    return CommentModel(
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
      repliesCount: json['replies_count'] as int?,
      replies: json['replies'] != null
          ? (json['replies'] as List)
                .map((e) => ReplyModel().fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
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
      'replies_count': repliesCount,
      'replies': replies?.map((e) => e.toJson()).toList(),
    };
  }
}

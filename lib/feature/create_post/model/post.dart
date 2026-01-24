import '../../../core/base/model/base.dart';

class PostModel extends BaseModel<PostModel> {
  String? id;
  String? postImageUrl;
  String? description;
  String? location;
  bool? isAnonymous;
  bool? allowComments;
  int? likesCount;
  int? commentsCount;
  int? savesCount;
  int? sharesCount;
  int? viewCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? tags;
  List<String>? mentionedUsers;

  PostModel({
    this.id,
    this.postImageUrl,
    this.description,
    this.location,
    this.isAnonymous,
    this.allowComments,
    this.likesCount,
    this.commentsCount,
    this.savesCount,
    this.sharesCount,
    this.viewCount,
    this.createdAt,
    this.updatedAt,
    this.tags,
    this.mentionedUsers,
  });

  @override
  PostModel copyWith({
    String? id,
    String? postImageUrl,
    String? description,
    String? location,
    bool? isAnonymous,
    bool? allowComments,
    int? likesCount,
    int? commentsCount,
    int? savesCount,
    int? sharesCount,
    int? viewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    List<String>? mentionedUsers,
  }) {
    return PostModel(
      id: id ?? this.id,
      postImageUrl: postImageUrl ?? this.postImageUrl,
      description: description ?? this.description,
      location: location ?? this.location,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowComments: allowComments ?? this.allowComments,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      savesCount: savesCount ?? this.savesCount,
      sharesCount: sharesCount ?? this.sharesCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
    );
  }

  @override
  PostModel fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String?,
      postImageUrl: json['post_image_url'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      isAnonymous: json['is_anonymous'] as bool?,
      allowComments: json['allow_comments'] as bool?,
      likesCount: json['likes_count'] as int?,
      commentsCount: json['comments_count'] as int?,
      savesCount: json['saves_count'] as int?,
      sharesCount: json['shares_count'] as int?,
      viewCount: json['view_count'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      mentionedUsers: (json['mentioned_users'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_image_url': postImageUrl,
      'description': description,
      'location': location,
      'is_anonymous': isAnonymous,
      'allow_comments': allowComments,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'saves_count': savesCount,
      'shares_count': sharesCount,
      'view_count': viewCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tags': tags,
      'mentioned_users': mentionedUsers,
    };
  }
}

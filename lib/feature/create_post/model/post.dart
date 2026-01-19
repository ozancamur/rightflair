import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/base/model/base.dart';
import '../../navigation/page/inbox/model/comment.dart';

class PostModel extends BaseModel<PostModel> {
  String? id;
  String? owner;
  String? image;
  String? description;
  List<String>? tags;
  List<String>? mentionedUsers;
  String? location;
  bool? isAnonymous;
  bool? commentsEnabled;
  bool? isDraft;
  bool? visibility;
  DateTime? createdAt;
  List<String>? likes;
  List<String>? saves;
  List<String>? shares;
  List<String>? views;
  List<CommentModel>? comments;

  PostModel({
    this.id,
    this.owner,
    this.image,
    this.description,
    this.tags,
    this.mentionedUsers,
    this.location,
    this.isAnonymous,
    this.commentsEnabled,
    this.isDraft,
    this.visibility,
    this.createdAt,
    this.likes,
    this.saves,
    this.shares,
    this.views,
    this.comments,
  });

  @override
  PostModel copyWith({
    String? id,
    String? owner,
    String? image,
    String? description,
    List<String>? tags,
    List<String>? mentionedUsers,
    String? location,
    bool? isAnonymous,
    bool? commentsEnabled,
    bool? isDraft,
    bool? visibility,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? saves,
    List<String>? shares,
    List<String>? views,
    List<CommentModel>? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      image: image ?? this.image,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      location: location ?? this.location,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      commentsEnabled: commentsEnabled ?? this.commentsEnabled,
      isDraft: isDraft ?? this.isDraft,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      saves: saves ?? this.saves,
      shares: shares ?? this.shares,
      views: views ?? this.views,
      comments: comments ?? this.comments,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      owner: json['owner'],
      image: json['image'],
      description: json['description'],
      tags: List<String>.from(json['tags'] ?? []),
      mentionedUsers: List<String>.from(json['mentionedUsers'] ?? []),
      location: json['location'],
      isAnonymous: json['isAnonymous'],
      commentsEnabled: json['commentsEnabled'],
      isDraft: json['isDraft'],
      visibility: json['visibility'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      likes: List<String>.from(json['likes'] ?? []),
      saves: List<String>.from(json['saves'] ?? []),
      shares: List<String>.from(json['shares'] ?? []),
      views: List<String>.from(json['views'] ?? []),
      comments: json['comments'] != null
          ? List<CommentModel>.from(
              (json['comments'] as List).map((x) => CommentModel().fromJson(x)),
            )
          : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner,
      'image': image,
      'description': description,
      'tags': tags,
      'mentionedUsers': mentionedUsers,
      'location': location,
      'isAnonymous': isAnonymous,
      'commentsEnabled': commentsEnabled,
      'isDraft': isDraft,
      'visibility': visibility,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'likes': likes,
      'saves': saves,
      'shares': shares,
      'views': views,
      'comments': comments?.map((x) => x.toJson()).toList(),
    };
  }
}

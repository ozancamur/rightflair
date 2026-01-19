import 'package:equatable/equatable.dart';

class FeedPostModel extends Equatable {
  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerAvatar;
  final String postImageUrl;
  final String? description;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final DateTime createdAt;
  final bool isLiked;
  final bool isSaved;

  const FeedPostModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatar,
    required this.postImageUrl,
    this.description,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.createdAt,
    this.isLiked = false,
    this.isSaved = false,
  });

  FeedPostModel copyWith({
    String? id,
    String? ownerId,
    String? ownerName,
    String? ownerAvatar,
    String? postImageUrl,
    String? description,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    DateTime? createdAt,
    bool? isLiked,
    bool? isSaved,
  }) {
    return FeedPostModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerAvatar: ownerAvatar ?? this.ownerAvatar,
      postImageUrl: postImageUrl ?? this.postImageUrl,
      description: description ?? this.description,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    return FeedPostModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      ownerAvatar: json['ownerAvatar'] as String,
      postImageUrl: json['postImageUrl'] as String,
      description: json['description'] as String?,
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      shareCount: json['shareCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isLiked: json['isLiked'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerAvatar': ownerAvatar,
      'postImageUrl': postImageUrl,
      'description': description,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'createdAt': createdAt.toIso8601String(),
      'isLiked': isLiked,
      'isSaved': isSaved,
    };
  }

  @override
  List<Object?> get props => [
    id,
    ownerId,
    ownerName,
    ownerAvatar,
    postImageUrl,
    description,
    likeCount,
    commentCount,
    shareCount,
    createdAt,
    isLiked,
    isSaved,
  ];
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/base/model/base.dart';

class CommentModel extends BaseModel<CommentModel> {
  String? id;
  String? ownerId;
  String? message;
  String? image;
  List<String>? likes;
  DateTime? createdAt;
  List<CommentModel>? replies;

  CommentModel({
    this.id,
    this.ownerId,
    this.message,
    this.image,
    this.likes,
    this.createdAt,
    this.replies,
  });

  @override
  copyWith({
    String? id,
    String? ownerId,
    String? message,
    String? image,
    List<String>? likes,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      message: message ?? this.message,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String?,
      ownerId: json['ownerId'] as String?,
      message: json['message'] as String?,
      image: json['image'] as String?,
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'message': message,
      'image': image,
      'likes': likes,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}

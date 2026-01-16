import '../../../../../core/base/base_modeld.dart';

class MessageModel extends BaseModel {
  String? id;
  String? ownerId;
  String? message;
  String? image;
  List<String>? likes;
  DateTime? createdAt;

  MessageModel({
    this.id,
    this.ownerId,
    this.message,
    this.image,
    this.likes,
    this.createdAt,
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
    return MessageModel(
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
    return MessageModel(
      id: json['id'] as String?,
      ownerId: json['ownerId'] as String?,
      message: json['message'] as String?,
      image: json['image'] as String?,
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
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
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

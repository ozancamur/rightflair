import '../../../../core/base/model/base.dart';

class CommentUserModel extends BaseModel<CommentUserModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;

  CommentUserModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
  });

  @override
  CommentUserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
  }) {
    return CommentUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }

  @override
  CommentUserModel fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}

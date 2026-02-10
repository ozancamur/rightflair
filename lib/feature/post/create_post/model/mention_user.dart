import '../../../../core/base/model/base.dart';

class MentionUserModel extends BaseModel<MentionUserModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;

  MentionUserModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
  });

  @override
  MentionUserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
  }) {
    return MentionUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }

  @override
  MentionUserModel fromJson(Map<String, dynamic> json) {
    return MentionUserModel(
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

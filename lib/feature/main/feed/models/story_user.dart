import '../../../../core/base/model/base.dart';

class StoryUserModel extends BaseModel<StoryUserModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;

  StoryUserModel({this.id, this.username, this.fullName, this.profilePhotoUrl});

  @override
  StoryUserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
  }) {
    return StoryUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }

  @override
  StoryUserModel fromJson(Map<String, dynamic> json) {
    return StoryUserModel(
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

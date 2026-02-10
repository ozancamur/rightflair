import '../../../../core/base/model/base.dart';

// ignore: must_be_immutable
class StoryUserModel extends BaseModel<StoryUserModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;

  StoryUserModel({this.id, this.username, this.fullName, this.profilePhotoUrl});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryUserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          fullName == other.fullName &&
          profilePhotoUrl == other.profilePhotoUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      fullName.hashCode ^
      profilePhotoUrl.hashCode;

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

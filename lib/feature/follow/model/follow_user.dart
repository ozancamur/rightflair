import '../../../core/base/model/base.dart';

class FollowUserModel extends BaseModel<FollowUserModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;
  bool? isFollowing;

  FollowUserModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
    this.isFollowing,
  });

  @override
  FollowUserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
    bool? isFollowing,
  }) {
    return FollowUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  FollowUserModel fromJson(Map<String, dynamic> json) {
    return FollowUserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['fullname'] as String?,
      profilePhotoUrl: json['profilephotourl'] as String?,
      isFollowing: json['isFollowing'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
      'is_following': isFollowing,
    };
  }
}

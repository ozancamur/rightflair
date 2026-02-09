import '../../../core/base/model/base.dart';

class NewFollowerModel extends BaseModel<NewFollowerModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;
  DateTime? followedAt;
  bool? isFollowingBack;

  NewFollowerModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
    this.followedAt,
    this.isFollowingBack,
  });

  @override
  NewFollowerModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
    DateTime? followedAt,
    bool? isFollowingBack,
  }) {
    return NewFollowerModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      followedAt: followedAt ?? this.followedAt,
      isFollowingBack: isFollowingBack ?? this.isFollowingBack,
    );
  }

  @override
  NewFollowerModel fromJson(Map<String, dynamic> json) {
    return NewFollowerModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      followedAt: json['followed_at'] != null
          ? DateTime.parse(json['followed_at'] as String)
          : null,
      isFollowingBack: json['is_following_back'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
      'followed_at': followedAt?.toIso8601String(),
      'is_following_back': isFollowingBack,
    };
  }
}

import '../../../../core/base/model/base.dart';

class SuggestedUserModel extends BaseModel<SuggestedUserModel> {
  String? id;
  String? username;
  String? fullName;
  String? profilePhotoUrl;
  String? bio;
  int? followersCount;
  int? followingCount;
  List<String>? styleTags;
  String? reason;
  int? mutualFriendsCount;
  int? commonTagsCount;

  SuggestedUserModel({
    this.id,
    this.username,
    this.fullName,
    this.profilePhotoUrl,
    this.bio,
    this.followersCount,
    this.followingCount,
    this.styleTags,
    this.reason,
    this.mutualFriendsCount,
    this.commonTagsCount,
  });

  @override
  SuggestedUserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profilePhotoUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    List<String>? styleTags,
    String? reason,
    int? mutualFriendsCount,
    int? commonTagsCount,
  }) {
    return SuggestedUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      bio: bio ?? this.bio,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      styleTags: styleTags ?? this.styleTags,
      reason: reason ?? this.reason,
      mutualFriendsCount: mutualFriendsCount ?? this.mutualFriendsCount,
      commonTagsCount: commonTagsCount ?? this.commonTagsCount,
    );
  }

  @override
  SuggestedUserModel fromJson(Map<String, dynamic> json) {
    return SuggestedUserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      bio: json['bio'] as String?,
      followersCount: json['followers_count'] as int?,
      followingCount: json['following_count'] as int?,
      styleTags: (json['style_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      reason: json['reason'] as String?,
      mutualFriendsCount: json['mutual_friends_count'] as int?,
      commonTagsCount: json['common_tags_count'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
      'bio': bio,
      'followers_count': followersCount,
      'following_count': followingCount,
      'style_tags': styleTags,
      'reason': reason,
      'mutual_friends_count': mutualFriendsCount,
      'common_tags_count': commonTagsCount,
    };
  }
}

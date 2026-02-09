import 'package:rightflair/core/base/model/base.dart';

class FollowResponseModel extends BaseModel<FollowResponseModel> {
  String? userId;
  bool? isFollowing;
  int? followersCount;
  bool? isMutual;

  FollowResponseModel({
    this.userId,
    this.isFollowing,
    this.followersCount,
    this.isMutual,
  });

  @override
  FollowResponseModel copyWith({
    String? userId,
    bool? isFollowing,
    int? followersCount,
    bool? isMutual,
  }) {
    return FollowResponseModel(
      userId: userId ?? this.userId,
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
      isMutual: isMutual ?? this.isMutual,
    );
  }

  @override
  FollowResponseModel fromJson(Map<String, dynamic> json) {
    return FollowResponseModel(
      userId: json['user_id'] as String?,
      isFollowing: json['is_following'] as bool?,
      followersCount: json['followers_count'] as int?,
      isMutual: json['is_mutual'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'is_following': isFollowing,
      'followers_count': followersCount,
      'is_mutual': isMutual,
    };
  }
}

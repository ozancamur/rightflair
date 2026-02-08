import '../../../core/base/model/base.dart';

class CheckToFollowingUserModel extends BaseModel<CheckToFollowingUserModel> {
  bool? isFollowing;
  bool? notifyNewPost;

  CheckToFollowingUserModel({this.isFollowing, this.notifyNewPost});

  @override
  CheckToFollowingUserModel copyWith({bool? isFollowing, bool? notifyNewPost}) {
    return CheckToFollowingUserModel(
      isFollowing: isFollowing ?? this.isFollowing,
      notifyNewPost: notifyNewPost ?? this.notifyNewPost,
    );
  }

  @override
  CheckToFollowingUserModel fromJson(Map<String, dynamic> json) {
    return CheckToFollowingUserModel(
      isFollowing: json['is_following'] as bool?,
      notifyNewPost: json['notify_new_post'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'is_following': isFollowing,
      'notify_new_post': notifyNewPost,
    };
  }
}

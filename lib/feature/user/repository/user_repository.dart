import 'package:rightflair/feature/main/profile/model/style_tags.dart';
import 'package:rightflair/feature/user/model/check_to_following_user.dart';

import '../../authentication/model/user.dart';
import '../../main/profile/model/request_post.dart';
import '../../main/profile/model/response_post.dart';
import '../../notifications/new_followers/model/follow_response.dart';

abstract class UserRepository {
  Future<UserModel?> getUser({required String userId});
  Future<StyleTagsModel?> getUserStyleTags({required String userId});

  Future<ResponsePostModel?> getUserPosts({
    required RequestPostModel parameters,
  });

  Future<CheckToFollowingUserModel?> checkFollowingUser({required String userId});
  Future<FollowResponseModel?> followUser({required String userId});



  Future<void> udateUserNotificationSettings({
    required String uid,
    required bool notification,
  });
}

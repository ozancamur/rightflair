import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';
import 'package:rightflair/feature/user/model/check_to_following_user.dart';

import '../../authentication/model/user.dart';
import '../../navigation/page/profile/model/request_post.dart';
import '../../navigation/page/profile/model/response_post.dart';
import '../../follow/model/follow_list_request.dart';
import '../../follow/model/follow_list_response.dart';
import '../../notifications/new_followers/model/follow_response.dart';

abstract class UserRepository {
  Future<UserModel?> getUser({required String userId});
  Future<StyleTagsModel?> getUserStyleTags({required String userId});

  Future<ResponsePostModel?> getUserPosts({
    required RequestPostModel parameters,
  });

  Future<CheckToFollowingUserModel?> checkFollowingUser({required String userId});
  Future<FollowResponseModel?> followUser({required String userId});

  Future<FollowListResponseModel?> getFollowersList({
    required FollowListRequestModel parameters,
  });

  Future<FollowListResponseModel?> getFollowingList({
    required FollowListRequestModel parameters,
  });

  Future<void> udateUserNotificationSettings({
    required String uid,
    required bool notification,
  });
}

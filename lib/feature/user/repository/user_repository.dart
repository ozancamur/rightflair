import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';

import '../../authentication/model/user.dart';
import '../../navigation/page/profile/model/request_post.dart';
import '../../navigation/page/profile/model/response_post.dart';

abstract class UserRepository {
  Future<UserModel?> getUser({required String userId});
  Future<StyleTagsModel?> getUserStyleTags({required String userId});

  Future<ResponsePostModel?> getUserPosts({
    required RequestPostModel parameters,
  });

  Future<bool?> checkFollowingUser({required String userId});
  Future<Map<String, dynamic>?> followUser({required String userId});
}


import 'package:rightflair/feature/main/profile/model/request_post.dart';
import 'package:rightflair/feature/main/profile/model/style_tags.dart';

import '../../../authentication/model/user.dart';
import '../model/response_post.dart';

abstract class ProfileRepository {
  Future<UserModel?> getUser();
  Future<ResponsePostModel?> getUserPosts({
    required RequestPostModel parameters,
  });
  Future<ResponsePostModel?> getUserSavedPosts({
    required RequestPostModel parameters,
  });
  Future<ResponsePostModel?> getUserDrafts({
    required RequestPostModel parameters,
  });
  Future<StyleTagsModel?> getUserStyleTags();
  Future<void> updateUser({String? profilePhotoUrl});
}

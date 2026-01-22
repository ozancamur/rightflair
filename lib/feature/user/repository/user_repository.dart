import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';

import '../../authentication/model/user.dart';

abstract class UserRepository {
  Future<UserModel?> getUser({required String userId});
  Future<void> getUserPosts({required String userId});
  Future<StyleTagsModel?> getUserStyleTags({required String userId});
}

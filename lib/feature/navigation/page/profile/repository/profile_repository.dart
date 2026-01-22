import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';

import '../../../../authentication/model/user.dart';

abstract class ProfileRepository {
  Future<UserModel?> getUser();
  Future<void> getUserPosts();
  Future<StyleTagsModel?> getUserStyleTags();
}

import 'dart:io';

import 'package:rightflair/feature/navigation/page/profile/model/create_story.dart';
import 'package:rightflair/feature/navigation/page/profile/model/request_post.dart';
import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';

import '../../../../authentication/model/user.dart';
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
  Future<String?> uploadStoryImage({
    required String userId,
    required File file,
  });
  Future<void> createStory({required CreateStoryModel data});
}

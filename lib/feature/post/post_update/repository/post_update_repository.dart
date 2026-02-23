import 'dart:io';

import '../../../../core/base/model/response.dart';
import '../../create_post/model/mention_user.dart';
import '../../create_post/model/music.dart';
import '../model/update_post.dart';

abstract class PostUpdateRepository {
  Future<ResponseModel?> updatePost({required UpdatePostModel post});
  Future<List<MentionUserModel>?> searchUsersForMention({
    required String query,
  });
  Future<List<MusicModel>?> searchSong({required String query});
  Future<String?> uploadPostImage({required String userId, required File file});
}

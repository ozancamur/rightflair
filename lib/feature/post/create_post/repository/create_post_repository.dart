import '../../../../core/base/model/response.dart';
import '../model/create_post.dart';
import '../model/mention_user.dart';
import '../model/music.dart';

abstract class CreatePostRepository {
  Future<ResponseModel?> createPost({required CreatePostModel post});
  Future<ResponseModel?> createDraft({required CreatePostModel post});
  Future<List<MentionUserModel>?> searchUsersForMention({
    required String query,
  });
  Future<List<MusicModel>?> searchSong({required String query});
}

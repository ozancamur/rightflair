import '../model/create_post.dart';
import '../model/mention_user.dart';

abstract class CreatePostRepository {
  Future<bool> createPost({required CreatePostModel post});
  Future<bool> createDraft({required CreatePostModel post});
  Future<List<MentionUserModel>?> searchUsersForMention({required String query});
}


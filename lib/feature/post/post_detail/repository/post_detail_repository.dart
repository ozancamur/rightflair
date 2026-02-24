import '../../create_post/model/post.dart';

abstract class PostDetailRepository {
  Future<void> savePost({required String pId});
  Future<bool> deletePost({required String pId});
  Future<PostModel?> getPostById({required String postId});
}

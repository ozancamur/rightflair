
abstract class PostDetailRepository {
  Future<void> savePost({required String pId});
  Future<bool> deletePost({required String pId});
}

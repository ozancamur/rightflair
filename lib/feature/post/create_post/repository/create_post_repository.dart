abstract class CreatePostRepository {
  Future<void> createPost();
}

class CreatePostRepositoryImpl implements CreatePostRepository {
  @override
  Future<void> createPost() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

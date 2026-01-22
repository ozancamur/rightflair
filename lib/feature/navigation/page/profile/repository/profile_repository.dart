import '../../../../authentication/model/user.dart';

abstract class ProfileRepository {
  Future<UserModel?> getUser();
  Future<void> getUserPosts();
}

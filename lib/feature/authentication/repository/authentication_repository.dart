import '../model/user.dart';

abstract class AuthenticationRepository {
  Future<UserModel?> createUser({required UserModel user});
}

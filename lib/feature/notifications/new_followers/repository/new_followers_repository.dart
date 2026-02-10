import '../model/response_new_followers.dart';
import '../model/suggested_user.dart';

abstract class NewFollowersRepository {
  Future<ResponseNewFollowersModel?> getNewFollowers({
    int page = 1,
    int limit = 6,
  });
  Future<SuggestedUserModel?> getSuggestedUsers({int page = 1, int limit = 10});
  Future<void> followUser({required String userId});
}

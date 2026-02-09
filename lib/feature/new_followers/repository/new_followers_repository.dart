
import '../model/response_new_followers.dart';
import '../model/suggested_user.dart';

abstract class NewFollowersRepository {
  Future<ResponseNewFollowersModel?> getNewFollowers();
  Future<SuggestedUserModel?> getSuggestedUsers();
  Future<void> followUser({required String userId});
}

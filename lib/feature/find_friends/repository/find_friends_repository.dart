import '../../notifications/new_followers/model/suggested_user.dart';

abstract class FindFriendsRepository {
  Future<SuggestedUserModel?> getSuggestedUsers({int page = 1, int limit = 10});

  Future<void> followUser({required String userId});

  Future<void> removeUser({required String userId});

  Future<SuggestedUserModel?> searchUsers({
    int page = 1,
    int limit = 20,
    String? search,
  });
}

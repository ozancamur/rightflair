import '../model/follow_list_request.dart';
import '../model/follow_list_response.dart';

abstract class FollowRepository {
  Future<FollowListResponseModel?> getFollowersList({
    required FollowListRequestModel parameters,
  });

  Future<FollowListResponseModel?> getFollowingList({
    required FollowListRequestModel parameters,
  });
}

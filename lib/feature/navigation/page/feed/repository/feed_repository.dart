import '../../profile/model/request_post.dart';
import '../../profile/model/response_post.dart';

abstract class FeedRepository {
  Future<ResponsePostModel?> fetchDiscoverFeed({required RequestPostModel body});
  Future<ResponsePostModel?> fetchFollowingFeed({required RequestPostModel body});
  Future<ResponsePostModel?> fetchFriendFeed({required RequestPostModel body});

  Future<void> likePost({required String pId});
  Future<void> dislikePost({required String pId});
}

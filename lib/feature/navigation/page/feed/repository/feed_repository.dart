import 'package:rightflair/feature/navigation/page/feed/models/request_comment.dart';

import '../../profile/model/request_post.dart';
import '../../profile/model/response_post.dart';
import '../models/comment.dart';

abstract class FeedRepository {
  
  // POSTS
  Future<ResponsePostModel?> fetchDiscoverFeed({required RequestPostModel body});
  Future<ResponsePostModel?> fetchFollowingFeed({required RequestPostModel body});
  Future<ResponsePostModel?> fetchFriendFeed({required RequestPostModel body});

  // LIKE & DISLIKE
  Future<void> likePost({required String pId});
  Future<void> dislikePost({required String pId});

  // COMMENTS
  Future<List<CommentModel>?> fetchPostComments({required String pId});
  Future<CommentModel?> sendCommentToPost({required RequestCommentModel body});

  // SAVE
  Future<void> savePost({required String pId});
  
}

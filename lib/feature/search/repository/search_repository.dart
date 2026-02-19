import 'package:rightflair/feature/main/feed/models/comment.dart';
import 'package:rightflair/feature/main/feed/models/request_comment.dart';

import '../model/request_search.dart';
import '../model/response_search.dart';

abstract class SearchRepository {
  Future<ResponseSearchModel?> searchPosts({required RequestSearchModel body});
  Future<bool> likePost({required String pId});
  Future<bool> dislikePost({required String pId});
  Future<void> savePost({required String pId});
  Future<List<CommentModel>?> fetchPostComments({required String pId});
  Future<CommentModel?> sendCommentToPost({required RequestCommentModel body});
}

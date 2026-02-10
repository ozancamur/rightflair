import '../../main/feed/models/comment.dart';
import '../../main/feed/models/request_comment.dart';

abstract class CommentsRepository {
    Future<List<CommentModel>?> fetchPostComments({required String pId});
  Future<CommentModel?> sendCommentToPost({required RequestCommentModel body});
}
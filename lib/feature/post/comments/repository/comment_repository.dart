import '../../../main/feed/models/comment.dart';
import '../../../main/feed/models/request_comment.dart';
import '../model/response_comment_like.dart';

abstract class CommentsRepository {
  Future<List<CommentModel>?> fetchPostComments({required String pId});
  Future<CommentModel?> sendCommentToPost({required RequestCommentModel body});
  Future<ResponseCommentLikeModel?> likeComment({required String cId});
  Future<bool> reportComment({
    required String commentId,
    required String reason,
    String? description,
  });
}

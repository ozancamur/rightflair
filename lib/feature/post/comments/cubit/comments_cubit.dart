import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/enums/report_reason.dart';
import '../../../main/feed/models/comment.dart';
import '../../../main/feed/models/request_comment.dart';
import '../repository/comments_repository_impl.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentsRepositoryImpl _repo;
  CommentsCubit(this._repo) : super(CommentsState());

  Future<void> init({required String pId}) async {
    emit(state.copyWith(isLoading: true));
    final comments = await _repo.fetchPostComments(pId: pId);
    emit(state.copyWith(comments: comments, isLoading: false));
  }

  Future<void> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    final RequestCommentModel request = RequestCommentModel(
      parentId: parentId,
      postId: postId,
      content: content,
    );

    final response = await _repo.sendCommentToPost(body: request);

    if (response != null) {
      final updatedComments = List<CommentModel>.from(state.comments ?? [])
        ..insert(0, response);

      emit(state.copyWith(comments: updatedComments));
    }
  }

  Future<void> likeComment({required String commentId}) async {
    final comments = state.comments;
    if (comments == null) return;

    final index = comments.indexWhere((c) => c.id == commentId);
    if (index == -1) return;

    final comment = comments[index];
    final currentlyLiked = comment.isLiked ?? false;

    // Optimistic update
    final updatedComments = List<CommentModel>.from(comments);
    updatedComments[index] = comment.copyWith(
      isLiked: !currentlyLiked,
      likesCount: (comment.likesCount ?? 0) + (currentlyLiked ? -1 : 1),
    );
    emit(state.copyWith(comments: updatedComments));

    // API call
    final response = await _repo.likeComment(cId: commentId);

    if (response != null) {
      final syncedComments = List<CommentModel>.from(state.comments ?? []);
      final syncIndex = syncedComments.indexWhere((c) => c.id == commentId);
      if (syncIndex != -1) {
        syncedComments[syncIndex] = syncedComments[syncIndex].copyWith(
          isLiked: response.isLiked,
          likesCount: response.likeCount,
        );
        emit(state.copyWith(comments: syncedComments));
      }
    } else {
      // Revert on failure
      final revertedComments = List<CommentModel>.from(state.comments ?? []);
      final revertIndex = revertedComments.indexWhere((c) => c.id == commentId);
      if (revertIndex != -1) {
        revertedComments[revertIndex] = comment;
        emit(state.copyWith(comments: revertedComments));
      }
    }
  }

  Future<bool> reportComment({
    required String commentId,
    required ReportReason reason,
    String? description,
  }) async {
    return await _repo.reportComment(
      commentId: commentId,
      reason: reason.value,
      description: description,
    );
  }
}

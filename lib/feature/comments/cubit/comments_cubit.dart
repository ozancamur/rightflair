import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main/feed/models/comment.dart';
import '../../main/feed/models/request_comment.dart';
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
}

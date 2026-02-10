import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/post/post_detail/repository/post_detail_repository_impl.dart';

import '../../create_post/model/post.dart';

part 'post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final PostDetailRepositoryImpl _repo;
  PostDetailCubit(this._repo)
    : super(PostDetailState(post: PostModel(), isLoading: false));

  void init({required PostModel post}) => emit(state.copyWith(post: post));

  Future<void> onSavePost() async {
    if (state.post.id == null) return;
    final updatedPost = state.post.copyWith(
      isSaved: !(state.post.isSaved ?? false),
      savesCount:
          (state.post.savesCount ?? 0) +
          (!(state.post.isSaved ?? false) ? 1 : -1),
    );

    emit(state.copyWith(post: updatedPost));
    await _repo.savePost(pId: state.post.id!);
  }

  void addComment() {
    final updatedPost = state.post.copyWith(
      commentsCount: (state.post.commentsCount ?? 0) + 1,
    );

    emit(state.copyWith(post: updatedPost));
  }

  Future<bool> deletePost() async {
    emit(state.copyWith(isLoading: true));
    if (state.post.id == null) return false;
    final response = await _repo.deletePost(pId: state.post.id!);
    emit(state.copyWith(isLoading: false));
    return response;
  }
}

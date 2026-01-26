import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/profile/model/request_post.dart';
import 'package:rightflair/feature/user/repository/user_repository_impl.dart';

import '../../authentication/model/user.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepositoryImpl _repo;
  UserCubit(this._repo)
    : super(
        UserState(
          user: UserModel(),
          isLoading: false,
          posts: [],
          isPostsLoading: false,
        ),
      );

  Future<void> init(BuildContext context, {required String userId}) async {
    await _getUser(userId: userId);
    await _getUserStyleTags(userId: userId);
    await _getUserPosts(userId: userId);
  }

  Future<void> _getUser({required String userId}) async {
    emit(state.copyWith(isLoading: true));
    final UserModel? user = await _repo.getUser(userId: userId);
    emit(state.copyWith(isLoading: false, user: user ?? UserModel()));
  }

  Future<void> _getUserStyleTags({required String userId}) async {
    final response = await _repo.getUserStyleTags(userId: userId);
    emit(state.copyWith(tags: response));
  }

  Future<void> _getUserPosts({required String userId}) async {
    emit(state.copyWith(isPostsLoading: true));
    final response = await _repo.getUserPosts(
      parameters: RequestPostModel().requestWithUserId(page: 1, userId: userId),
    );
    emit(
      state.copyWith(
        posts: response?.posts ?? [],
        pagination: response?.pagination,
        isPostsLoading: false,
        isLoadingMorePosts: false,
      ),
    );
  }
}

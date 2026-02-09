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
    await checkFollowingUser(userId: userId);
  }

  Future<void> _getUser({required String userId}) async {
    if (!isClosed) emit(state.copyWith(isLoading: true));
    final UserModel? user = await _repo.getUser(userId: userId);
    if (!isClosed) {
      emit(state.copyWith(isLoading: false, user: user ?? UserModel()));
    }
  }

  Future<void> _getUserStyleTags({required String userId}) async {
    final response = await _repo.getUserStyleTags(userId: userId);
    if (!isClosed) emit(state.copyWith(tags: response));
  }

  Future<void> _getUserPosts({required String userId}) async {
    if (!isClosed) emit(state.copyWith(isPostsLoading: true));
    final response = await _repo.getUserPosts(
      parameters: RequestPostModel().requestWithUserId(page: 1, userId: userId),
    );
    if (!isClosed) {
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

  Future<void> checkFollowingUser({required String userId}) async {
    if (!isClosed) emit(state.copyWith(isFollowLoading: true));
    final response = await _repo.checkFollowingUser(userId: userId);
    if (!isClosed) {
      emit(
        state.copyWith(
          isFollowing: response?.isFollowing ?? false,
          isNotificationEnabled: response?.notifyNewPost ?? false,
          isFollowLoading: false,
        ),
      );
    }
  }

  Future<void> followUser({required String userId}) async {
    // Optimistic UI update - API beklemeden hemen güncelle
    final bool currentIsFollowing = state.isFollowing;
    final int currentFollowersCount = state.user.followersCount ?? 0;
    final int newFollowersCount = currentIsFollowing
        ? currentFollowersCount - 1
        : currentFollowersCount + 1;

    if (!isClosed) {
      emit(
        state.copyWith(
          isFollowing: !currentIsFollowing,
          user: state.user.copyWith(followersCount: newFollowersCount),
        ),
      );
    }

    // API isteği arka planda gönder
    final response = await _repo.followUser(userId: userId);
    if (!isClosed) {
      if (response != null) {
        final bool isFollowing = response.isFollowing ?? false;
        final int followersCount =
            response.followersCount ?? newFollowersCount;
        emit(
          state.copyWith(
            isFollowing: isFollowing,
            user: state.user.copyWith(followersCount: followersCount),
          ),
        );
      } else {
        // API başarısız olursa eski duruma geri dön
        emit(
          state.copyWith(
            isFollowing: currentIsFollowing,
            user: state.user.copyWith(followersCount: currentFollowersCount),
          ),
        );
      }
    }
  }

  Future<void> updateUserNotification({
    required String uid,
    required bool notification,
  }) async {
    emit(state.copyWith(isNotificationEnabled: notification));
    await _repo.udateUserNotificationSettings(
      uid: uid,
      notification: notification,
    );
  }
}

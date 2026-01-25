import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/feed/repository/feed_repository_impl.dart';
import 'package:rightflair/feature/navigation/page/profile/model/request_post.dart';
import 'package:rightflair/feature/navigation/page/profile/model/response_post.dart';

import '../../../../create_post/model/post.dart';
import '../../profile/model/pagination.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepositoryImpl _repo;
  FeedBloc(this._repo) : super(const FeedState()) {
    on<LoadPostInitializeEvent>(_onLoadPostInitializeEvent);
    on<SwipeRightEvent>(_onSwipeRight);
    on<SwipeLeftEvent>(_onSwipeLeft);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<ChangeTabEvent>(_onChangeTab);
  }

  Future<void> _onLoadPostInitializeEvent(
    LoadPostInitializeEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          posts: [],
          pagination: PaginationModel().reset(),
        ),
      );
      final response = await _load(
        index: event.currentTabIndex,
        request: RequestPostModel().requestSortByDateOrderDesc(page: 1),
      );
      emit(
        state.copyWith(
          isLoading: false,
          posts: response?.posts ?? [],
          pagination: response?.pagination,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: "", isLoading: false, isLoadingMore: false));
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      if (state.isLoadingMore || state.pagination?.hasNext == false) {
        emit(state.copyWith(isLoadingMore: false));
        return;
      }
      emit(state.copyWith(isLoadingMore: true));

      if (state.pagination?.hasNext == true) {
        final response = await _load(
          index: event.tabIndex,
          request: RequestPostModel().requestSortByDateOrderDesc(
            page: (state.pagination?.page ?? 0) + 1,
          ),
        );
        final updatedPosts = List<PostModel>.from(state.posts ?? [])
          ..addAll(response?.posts ?? []);
        emit(
          state.copyWith(
            isLoadingMore: false,
            posts: updatedPosts,
            pagination: response?.pagination,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: "", isLoading: false, isLoadingMore: false));
    }
  }

  Future<ResponsePostModel?> _load({
    required int index,
    required RequestPostModel request,
  }) async {
    switch (index) {
      case 0:
        return await _discover(request: request);
      case 1:
        return await _following(request: request);
      case 2:
        return await _friend(request: request);
      default:
        return null;
    }
  }

  Future<ResponsePostModel?> _discover({
    required RequestPostModel request,
  }) async => await _repo.fetchDiscoverFeed(body: request);

  Future<ResponsePostModel?> _following({
    required RequestPostModel request,
  }) async => await _repo.fetchFollowingFeed(body: request);

  Future<ResponsePostModel?> _friend({
    required RequestPostModel request,
  }) async => await _repo.fetchFriendFeed(body: request);

  Future<void> _onSwipeRight(
    SwipeRightEvent event,
    Emitter<FeedState> emit,
  ) async {
    updateListAfterSwipe(emit, event.postId);
    await _repo.likePost(pId: event.postId);
  }

  Future<void> _onSwipeLeft(
    SwipeLeftEvent event,
    Emitter<FeedState> emit,
  ) async {
    updateListAfterSwipe(emit, event.postId);
    await _repo.dislikePost(pId: event.postId);
  }

  void updateListAfterSwipe(Emitter<FeedState> emit, String postId) {
    final updatedPosts = List<PostModel>.from(state.posts ?? [])
      ..removeWhere((post) => post.id == postId);
    emit(state.copyWith(posts: updatedPosts));
    if (updatedPosts.length <= 1 && !state.isLoadingMore) {
      add(LoadMorePostsEvent(state.currentTabIndex));
    }
  }

  Future<void> _onChangeTab(
    ChangeTabEvent event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(currentTabIndex: event.tabIndex));
  }
}

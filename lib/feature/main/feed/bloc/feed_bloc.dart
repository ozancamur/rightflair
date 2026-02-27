import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/main/feed/models/friends_feed_response.dart';
import 'package:rightflair/feature/main/feed/models/suggested_user.dart';
import 'package:rightflair/feature/main/feed/repository/feed_repository_impl.dart';
import 'package:rightflair/feature/main/profile/model/request_post.dart';
import 'package:rightflair/feature/main/profile/model/response_post.dart';

import '../../../post/create_post/model/post.dart';
import '../../profile/model/pagination.dart';
import '../models/comment.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepositoryImpl _repo;
  FeedBloc(this._repo) : super(const FeedState()) {
    on<FeedInitializeEvent>(_onInitialize);
    on<SwipeRightEvent>(_onSwipeRight);
    on<SwipeLeftEvent>(_onSwipeLeft);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<ChangeTabEvent>(_onChangeTab);
    on<RefreshTabEvent>(_onRefreshTab);
    on<SendCommentToPostEvent>(_onSendComment);
    on<SavePostEvent>(_onSavePost);
    on<RemoveSuggestedUserEvent>(_onRemoveSuggestedUser);
    on<FollowSuggestedUserEvent>(_onFollowSuggestedUser);
  }

  // ─────────────────────────────────────────
  // INITIALIZE — fetch all 3 tabs in parallel
  // ─────────────────────────────────────────

  Future<void> _onInitialize(
    FeedInitializeEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isLoadingDiscover: true,
          isLoadingFollowing: true,
          isLoadingFriends: true,
          discoverPosts: [],
          followingPosts: [],
          friendsPosts: [],
          discoverPagination: PaginationModel().reset(),
          followingPagination: PaginationModel().reset(),
          friendsPagination: PaginationModel().reset(),
        ),
      );

      final request = RequestPostModel().requestSortByDateOrderDesc(page: 1);

      final results = await Future.wait([
        _discover(request: request),
        _following(request: request),
        _friend(request: request),
      ]);

      final discoverResult = results[0] as ResponsePostModel?;
      final followingResult = results[1] as ResponsePostModel?;
      final friendResult = results[2] as FriendsFeedResponseModel?;

      emit(
        state.copyWith(
          isLoadingDiscover: false,
          discoverPosts: discoverResult?.posts ?? [],
          discoverPagination: discoverResult?.pagination,
          isLoadingFollowing: false,
          followingPosts: followingResult?.posts ?? [],
          followingPagination: followingResult?.pagination,
          isLoadingFriends: false,
          friendsPosts: friendResult?.posts ?? [],
          friendsPagination: friendResult?.pagination,
          suggestedUsers: friendResult?.suggestedUsers ?? [],
          friendsFeedState: friendResult?.feedState ?? 'has_more',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: '',
          isLoadingDiscover: false,
          isLoadingFollowing: false,
          isLoadingFriends: false,
          isLoadingMoreDiscover: false,
          isLoadingMoreFollowing: false,
          isLoadingMoreFriends: false,
        ),
      );
    }
  }

  // ─────────────────────────────────────────
  // LOAD MORE — per tab
  // ─────────────────────────────────────────

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final tabIndex = event.tabIndex;
      final pagination = state.paginationForTab(tabIndex);
      final isAlreadyLoading = state.isLoadingMoreForTab(tabIndex);

      if (isAlreadyLoading || pagination?.hasNext == false) return;

      _emitLoadingMore(emit, tabIndex, true);

      final nextPage = (pagination?.page ?? 0) + 1;
      final request = RequestPostModel().requestSortByDateOrderDesc(
        page: nextPage,
      );

      switch (tabIndex) {
        case 0:
          final response = await _discover(request: request);
          final updated = List<PostModel>.from(state.discoverPosts ?? [])
            ..addAll(response?.posts ?? []);
          emit(
            state.copyWith(
              isLoadingMoreDiscover: false,
              discoverPosts: updated,
              discoverPagination: response?.pagination,
            ),
          );
          break;
        case 1:
          final response = await _following(request: request);
          final updated = List<PostModel>.from(state.followingPosts ?? [])
            ..addAll(response?.posts ?? []);
          emit(
            state.copyWith(
              isLoadingMoreFollowing: false,
              followingPosts: updated,
              followingPagination: response?.pagination,
            ),
          );
          break;
        case 2:
          final response = await _friend(request: request);
          final updated = List<PostModel>.from(state.friendsPosts ?? [])
            ..addAll(response?.posts ?? []);
          emit(
            state.copyWith(
              isLoadingMoreFriends: false,
              friendsPosts: updated,
              friendsPagination: response?.pagination,
              suggestedUsers: response?.suggestedUsers ?? state.suggestedUsers,
              friendsFeedState: response?.feedState ?? state.friendsFeedState,
            ),
          );
          break;
      }
    } catch (e) {
      _emitLoadingMore(emit, event.tabIndex, false);
    }
  }

  void _emitLoadingMore(Emitter<FeedState> emit, int tabIndex, bool loading) {
    switch (tabIndex) {
      case 0:
        emit(state.copyWith(isLoadingMoreDiscover: loading));
        break;
      case 1:
        emit(state.copyWith(isLoadingMoreFollowing: loading));
        break;
      case 2:
        emit(state.copyWith(isLoadingMoreFriends: loading));
        break;
    }
  }

  // ─────────────────────────────────────────
  // REFRESH — per tab (pull-to-refresh)
  // ─────────────────────────────────────────

  Future<void> _onRefreshTab(
    RefreshTabEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final tabIndex = event.tabIndex;
      final request = RequestPostModel().requestSortByDateOrderDesc(page: 1);

      switch (tabIndex) {
        case 0:
          emit(state.copyWith(isLoadingDiscover: true));
          final response = await _discover(request: request);
          emit(
            state.copyWith(
              isLoadingDiscover: false,
              discoverPosts: response?.posts ?? [],
              discoverPagination: response?.pagination,
            ),
          );
          break;
        case 1:
          emit(state.copyWith(isLoadingFollowing: true));
          final response = await _following(request: request);
          emit(
            state.copyWith(
              isLoadingFollowing: false,
              followingPosts: response?.posts ?? [],
              followingPagination: response?.pagination,
            ),
          );
          break;
        case 2:
          emit(state.copyWith(isLoadingFriends: true));
          final response = await _friend(request: request);
          emit(
            state.copyWith(
              isLoadingFriends: false,
              friendsPosts: response?.posts ?? [],
              friendsPagination: response?.pagination,
              suggestedUsers: response?.suggestedUsers ?? [],
              friendsFeedState: response?.feedState ?? 'has_more',
            ),
          );
          break;
      }
    } catch (e) {
      emit(
        state.copyWith(
          error: '',
          isLoadingDiscover: false,
          isLoadingFollowing: false,
          isLoadingFriends: false,
        ),
      );
    }
  }

  // ─────────────────────────────────────────
  // DATA LOADERS
  // ─────────────────────────────────────────

  Future<ResponsePostModel?> _discover({
    required RequestPostModel request,
  }) async => await _repo.fetchDiscoverFeed(body: request);

  Future<ResponsePostModel?> _following({
    required RequestPostModel request,
  }) async => await _repo.fetchFollowingFeed(body: request);

  Future<FriendsFeedResponseModel?> _friend({
    required RequestPostModel request,
  }) async => await _repo.fetchFriendFeed(body: request);

  // ─────────────────────────────────────────
  // SWIPE
  // ─────────────────────────────────────────

  Future<void> _onSwipeRight(
    SwipeRightEvent event,
    Emitter<FeedState> emit,
  ) async {
    _updateListAfterSwipe(emit, event.postId);
    await _repo.likePost(pId: event.postId);
  }

  Future<void> _onSwipeLeft(
    SwipeLeftEvent event,
    Emitter<FeedState> emit,
  ) async {
    _updateListAfterSwipe(emit, event.postId);
    await _repo.dislikePost(pId: event.postId);
  }

  void _updateListAfterSwipe(Emitter<FeedState> emit, String postId) {
    final tabIndex = state.currentTabIndex;

    switch (tabIndex) {
      case 0:
        final updated = List<PostModel>.from(state.discoverPosts ?? [])
          ..removeWhere((p) => p.id == postId);
        emit(state.copyWith(discoverPosts: updated));
        if (updated.length <= 1 && !state.isLoadingMoreDiscover) {
          add(LoadMorePostsEvent(tabIndex));
        }
        break;
      case 1:
        final updated = List<PostModel>.from(state.followingPosts ?? [])
          ..removeWhere((p) => p.id == postId);
        emit(state.copyWith(followingPosts: updated));
        if (updated.length <= 1 && !state.isLoadingMoreFollowing) {
          add(LoadMorePostsEvent(tabIndex));
        }
        break;
      case 2:
        final updated = List<PostModel>.from(state.friendsPosts ?? [])
          ..removeWhere((p) => p.id == postId);
        emit(state.copyWith(friendsPosts: updated));
        if (updated.length <= 1 && !state.isLoadingMoreFriends) {
          add(LoadMorePostsEvent(tabIndex));
        }
        break;
    }
  }

  // ─────────────────────────────────────────
  // TAB CHANGE
  // ─────────────────────────────────────────

  Future<void> _onChangeTab(
    ChangeTabEvent event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(currentTabIndex: event.tabIndex));
  }

  // ─────────────────────────────────────────
  // COMMENT
  // ─────────────────────────────────────────

  Future<void> _onSendComment(
    SendCommentToPostEvent event,
    Emitter<FeedState> emit,
  ) async {
    _updatePostInAllTabs(emit, event.postId, (post) {
      return post.copyWith(commentsCount: (post.commentsCount ?? 0) + 1);
    });
  }

  // ─────────────────────────────────────────
  // SAVE POST
  // ─────────────────────────────────────────

  Future<void> _onSavePost(SavePostEvent event, Emitter<FeedState> emit) async {
    if (event.postId == null) return;

    final previousState = state;

    _updatePostInAllTabs(emit, event.postId!, (post) {
      final isSaved = post.isSaved ?? false;
      return post.copyWith(
        isSaved: !isSaved,
        savesCount: (post.savesCount ?? 0) + (!isSaved ? 1 : -1),
      );
    });

    try {
      await _repo.savePost(pId: event.postId!);
    } catch (e) {
      // Rollback
      emit(previousState);
    }
  }

  // ─────────────────────────────────────────
  // SUGGESTED USER ACTIONS
  // ─────────────────────────────────────────

  Future<void> _onRemoveSuggestedUser(
    RemoveSuggestedUserEvent event,
    Emitter<FeedState> emit,
  ) async {
    final updated = List<SuggestedUserModel>.from(state.suggestedUsers ?? [])
      ..removeWhere((u) => u.id == event.userId);
    emit(state.copyWith(suggestedUsers: updated));
  }

  Future<void> _onFollowSuggestedUser(
    FollowSuggestedUserEvent event,
    Emitter<FeedState> emit,
  ) async {
    // Optimistic: remove from list
    final updated = List<SuggestedUserModel>.from(state.suggestedUsers ?? [])
      ..removeWhere((u) => u.id == event.userId);
    emit(state.copyWith(suggestedUsers: updated));

    try {
      await _repo.followUser(userId: event.userId);
    } catch (_) {
      // Silently fail — user is already removed from suggestions
    }
  }

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────

  void _updatePostInAllTabs(
    Emitter<FeedState> emit,
    String postId,
    PostModel Function(PostModel post) updater,
  ) {
    final dPosts = state.discoverPosts
        ?.map((p) => p.id == postId ? updater(p) : p)
        .toList();
    final fPosts = state.followingPosts
        ?.map((p) => p.id == postId ? updater(p) : p)
        .toList();
    final frPosts = state.friendsPosts
        ?.map((p) => p.id == postId ? updater(p) : p)
        .toList();

    emit(
      state.copyWith(
        discoverPosts: dPosts,
        followingPosts: fPosts,
        friendsPosts: frPosts,
      ),
    );
  }
}

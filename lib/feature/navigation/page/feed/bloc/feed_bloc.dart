import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/navigation/page/feed/models/my_story.dart';
import 'package:rightflair/feature/navigation/page/feed/models/story.dart';
import 'package:rightflair/feature/navigation/page/feed/models/user_with_stories.dart';
import 'package:rightflair/feature/navigation/page/feed/repository/feed_repository_impl.dart';
import 'package:rightflair/feature/navigation/page/profile/model/request_post.dart';
import 'package:rightflair/feature/navigation/page/profile/model/response_post.dart';

import '../../../../create_post/model/post.dart';
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
    on<SendCommentToPostEvent>(_onSendComment);
    on<SavePostEvent>(_onSavePost);
    on<LoadMoreStoriesEvent>(_onLoadMoreStories);
    on<StoryViewedEvent>(_onStoryViewed);
  }

  Future<void> _onInitialize(
    FeedInitializeEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          posts: [],
          postPagination: PaginationModel().reset(),
        ),
      );
      final story = await _repo.fetchStories(
        pagination: PaginationModel().forConversations(page: 1),
      );
      final post = await _load(
        index: event.currentTabIndex,
        request: RequestPostModel().requestSortByDateOrderDesc(page: 1),
      );

      final myStory = await _repo.fetchMyStories();

      // Sort and update stories
      final sortedStories = _sortAndUpdateStories(
        story?.usersWithStories ?? [],
      );

      emit(
        state.copyWith(
          isLoading: false,
          posts: post?.posts ?? [],
          postPagination: post?.pagination,
          myStory: myStory,
          stories: sortedStories,
          storyPagination: story?.pagination,
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
      if (state.isLoadingMore || state.postPagination?.hasNext == false) {
        emit(state.copyWith(isLoadingMore: false));
        return;
      }
      emit(state.copyWith(isLoadingMore: true));

      if (state.postPagination?.hasNext == true) {
        final response = await _load(
          index: event.tabIndex,
          request: RequestPostModel().requestSortByDateOrderDesc(
            page: (state.postPagination?.page ?? 0) + 1,
          ),
        );
        final updatedPosts = List<PostModel>.from(state.posts ?? [])
          ..addAll(response?.posts ?? []);
        emit(
          state.copyWith(
            isLoadingMore: false,
            posts: updatedPosts,
            postPagination: response?.pagination,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: "", isLoading: false, isLoadingMore: false));
    }
  }

  Future<void> _onLoadMoreStories(
    LoadMoreStoriesEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      if (state.isLoadingMore || state.storyPagination?.hasNext == false) {
        emit(state.copyWith(isLoadingMore: false));
        return;
      }
      emit(state.copyWith(isLoadingMore: true));

      if (state.storyPagination?.hasNext == true) {
        final response = await _repo.fetchStories(
          pagination: PaginationModel().forConversations(
            page: (state.storyPagination?.page ?? 0) + 1,
          ),
        );
        final updatedStories = List<UserWithStoriesModel>.from(
          state.stories ?? [],
        )..addAll(response?.usersWithStories ?? []);

        // Sort and update stories
        final sortedStories = _sortAndUpdateStories(updatedStories);

        emit(
          state.copyWith(
            isLoadingMore: false,
            stories: sortedStories,
            storyPagination: response?.pagination,
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
    final updatedPosts = List<PostModel>.from(state.posts ?? [])
      ..removeWhere((post) => post.id == postId);
    emit(state.copyWith(posts: updatedPosts));
    if (updatedPosts.length <= 1 && !state.isLoadingMore) {
      add(LoadMorePostsEvent(state.currentTabIndex));
    }
  }

  List<UserWithStoriesModel> _sortAndUpdateStories(
    List<UserWithStoriesModel> stories,
  ) {
    final updatedStories = stories.map((userStory) {
      final sortedUserStories = List<StoryModel>.from(userStory.stories ?? []);
      sortedUserStories.sort((a, b) {
        final aViewed = a.isViewed ?? false;
        final bViewed = b.isViewed ?? false;

        if (aViewed != bViewed) {
          return aViewed ? 1 : -1;
        }

        final aDate = a.createdAt;
        final bDate = b.createdAt;

        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;

        return bDate.compareTo(aDate);
      });

      final hasUnseenStories = sortedUserStories.any(
        (story) => (story.isViewed ?? false) == false,
      );

      final latestStory = sortedUserStories.isNotEmpty
          ? sortedUserStories.reduce((curr, next) {
              final currDate = curr.createdAt;
              final nextDate = next.createdAt;
              if (currDate == null) return next;
              if (nextDate == null) return curr;
              return currDate.isAfter(nextDate) ? curr : next;
            })
          : null;
      final latestStoryAt = latestStory?.createdAt;

      return userStory.copyWith(
        stories: sortedUserStories,
        hasUnseenStories: hasUnseenStories,
        latestStoryAt: latestStoryAt,
      );
    }).toList();

    updatedStories.sort((a, b) {
      final aHasUnseen = a.hasUnseenStories ?? false;
      final bHasUnseen = b.hasUnseenStories ?? false;

      if (aHasUnseen != bHasUnseen) {
        return aHasUnseen ? -1 : 1;
      }

      final aDate = a.latestStoryAt;
      final bDate = b.latestStoryAt;

      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      return bDate.compareTo(aDate);
    });

    return updatedStories;
  }

  Future<void> _onChangeTab(
    ChangeTabEvent event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(currentTabIndex: event.tabIndex));
  }

  Future<void> _onSendComment(
    SendCommentToPostEvent event,
    Emitter<FeedState> emit,
  ) async {
    final updatedPosts = state.posts?.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(commentsCount: (post.commentsCount ?? 0) + 1);
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts));
  }

  Future<void> _onSavePost(SavePostEvent event, Emitter<FeedState> emit) async {
    if (event.postId == null) return;

    // Önceki state'i sakla (hata durumunda geri almak için)
    final previousPosts = state.posts;

    // Optimistic update: UI'ı hemen güncelle
    final updatedPosts = state.posts?.map((post) {
      if (post.id == event.postId) {
        final isSaved = post.isSaved ?? false;
        return post.copyWith(
          isSaved: !isSaved,
          savesCount: (post.savesCount ?? 0) + (!isSaved ? 1 : -1),
        );
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts));

    try {
      await _repo.savePost(pId: event.postId!);
    } catch (e) {
      // Hata durumunda optimistic update'i geri al
      emit(state.copyWith(posts: previousPosts));
    }
  }

  Future<void> _onStoryViewed(
    StoryViewedEvent event,
    Emitter<FeedState> emit,
  ) async {
    final updatedStories = state.stories?.map((userStory) {
      if (userStory.user?.id == event.userId) {
        final updatedUserStories = userStory.stories?.map((story) {
          if (story.id == event.storyId) {
            return story.copyWith(isViewed: true);
          }
          return story;
        }).toList();

        final hasUnseenStories =
            updatedUserStories?.any(
              (story) => (story.isViewed ?? false) == false,
            ) ??
            false;

        return userStory.copyWith(
          stories: updatedUserStories,
          hasUnseenStories: hasUnseenStories,
        );
      }
      return userStory;
    }).toList();

    // Re-sort stories after updating
    final sortedStories = _sortAndUpdateStories(updatedStories ?? []);

    emit(state.copyWith(stories: sortedStories));
  }
}

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/feed_post_model.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(const FeedState()) {
    on<LoadFeedEvent>(_onLoadFeed);
    on<SwipeRightEvent>(_onSwipeRight);
    on<SwipeLeftEvent>(_onSwipeLeft);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<ChangeTabEvent>(_onChangeTab);
  }

  Future<void> _onLoadFeed(LoadFeedEvent event, Emitter<FeedState> emit) async {
    try {
      emit(state.copyWith(status: FeedStatus.loading));

      // Simüle edilmiş API çağrısı - gerçek uygulamada repository kullanılacak
      await Future.delayed(const Duration(seconds: 1));

      final posts = _generateMockPosts(event.tabIndex, 0);

      final updatedTabPosts = Map<int, List<FeedPostModel>>.from(
        state.tabPosts,
      );
      updatedTabPosts[event.tabIndex] = posts;

      final updatedHasReachedMax = Map<int, bool>.from(state.hasReachedMax);
      updatedHasReachedMax[event.tabIndex] = false;

      emit(
        state.copyWith(
          status: FeedStatus.success,
          tabPosts: updatedTabPosts,
          hasReachedMax: updatedHasReachedMax,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FeedStatus.failure,
          errorMessage: 'Post yüklenirken bir hata oluştu: $e',
        ),
      );
    }
  }

  Future<void> _onSwipeRight(
    SwipeRightEvent event,
    Emitter<FeedState> emit,
  ) async {
    final currentPosts = state.getPostsForTab(event.tabIndex);

    // Post'u listeden kaldır
    final updatedPosts = List<FeedPostModel>.from(currentPosts)
      ..removeWhere((post) => post.id == event.postId);

    // Eğer post sayısı azaldıysa, yeni post yükle
    if (updatedPosts.length < 3 &&
        !(state.hasReachedMax[event.tabIndex] ?? false)) {
      final newPosts = _generateMockPosts(event.tabIndex, updatedPosts.length);
      updatedPosts.addAll(newPosts);
    }

    final updatedTabPosts = Map<int, List<FeedPostModel>>.from(state.tabPosts);
    updatedTabPosts[event.tabIndex] = updatedPosts;

    emit(state.copyWith(tabPosts: updatedTabPosts));

    // Beğenme işlemini backend'e gönder (simüle edilmiş)
    await _likePost(event.postId);
  }

  Future<void> _onSwipeLeft(
    SwipeLeftEvent event,
    Emitter<FeedState> emit,
  ) async {
    final currentPosts = state.getPostsForTab(event.tabIndex);

    // Post'u listeden kaldır
    final updatedPosts = List<FeedPostModel>.from(currentPosts)
      ..removeWhere((post) => post.id == event.postId);

    // Eğer post sayısı azaldıysa, yeni post yükle
    if (updatedPosts.length < 3 &&
        !(state.hasReachedMax[event.tabIndex] ?? false)) {
      final newPosts = _generateMockPosts(event.tabIndex, updatedPosts.length);
      updatedPosts.addAll(newPosts);
    }

    final updatedTabPosts = Map<int, List<FeedPostModel>>.from(state.tabPosts);
    updatedTabPosts[event.tabIndex] = updatedPosts;

    emit(state.copyWith(tabPosts: updatedTabPosts));

    // Beğenmeme işlemini backend'e gönder (simüle edilmiş)
    await _dislikePost(event.postId);
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<FeedState> emit,
  ) async {
    if (state.hasReachedMax[event.tabIndex] ?? false) return;

    try {
      final currentPosts = state.getPostsForTab(event.tabIndex);

      await Future.delayed(const Duration(milliseconds: 500));

      final newPosts = _generateMockPosts(event.tabIndex, currentPosts.length);

      if (newPosts.isEmpty) {
        final updatedHasReachedMax = Map<int, bool>.from(state.hasReachedMax);
        updatedHasReachedMax[event.tabIndex] = true;
        emit(state.copyWith(hasReachedMax: updatedHasReachedMax));
        return;
      }

      final updatedPosts = List<FeedPostModel>.from(currentPosts)
        ..addAll(newPosts);
      final updatedTabPosts = Map<int, List<FeedPostModel>>.from(
        state.tabPosts,
      );
      updatedTabPosts[event.tabIndex] = updatedPosts;

      emit(state.copyWith(tabPosts: updatedTabPosts));
    } catch (e) {
      emit(
        state.copyWith(
          status: FeedStatus.failure,
          errorMessage: 'Daha fazla post yüklenirken hata oluştu: $e',
        ),
      );
    }
  }

  Future<void> _onChangeTab(
    ChangeTabEvent event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(currentTabIndex: event.tabIndex));

    // Eğer bu tab için henüz post yüklenmediyse, yükle
    if (!state.hasPostsForTab(event.tabIndex)) {
      add(LoadFeedEvent(event.tabIndex));
    }
  }

  // Mock veri üretimi - gerçek uygulamada API'den gelecek
  List<FeedPostModel> _generateMockPosts(int tabIndex, int startIndex) {
    final tabNames = ['Trend', 'Takip', 'Keşfet'];
    final posts = <FeedPostModel>[];

    // Her seferinde 5 post üret
    for (int i = 0; i < 5; i++) {
      final index = startIndex + i;
      posts.add(
        FeedPostModel(
          id: 'post_${tabIndex}_$index',
          ownerId: 'user_$index',
          ownerName: 'User ${index + 1}',
          ownerAvatar: 'https://i.pravatar.cc/150?img=$index',
          postImageUrl: 'https://picsum.photos/400/600?random=$index$tabIndex',
          description: '${tabNames[tabIndex]} tab - Post $index açıklaması',
          likeCount: (index * 10) + 100,
          commentCount: (index * 5) + 20,
          shareCount: (index * 2) + 5,
          createdAt: DateTime.now().subtract(Duration(hours: index)),
        ),
      );
    }

    return posts;
  }

  Future<void> _likePost(String postId) async {
    // API çağrısı simülasyonu
    await Future.delayed(const Duration(milliseconds: 300));
    print('Post beğenildi: $postId');
  }

  Future<void> _dislikePost(String postId) async {
    // API çağrısı simülasyonu
    await Future.delayed(const Duration(milliseconds: 300));
    print('Post beğenilmedi: $postId');
  }
}

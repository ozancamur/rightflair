import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main/inbox/model/notification_sender.dart';
import '../repository/find_friends_repository_impl.dart';
import 'find_friends_state.dart';

class FindFriendsCubit extends Cubit<FindFriendsState> {
  final FindFriendsRepositoryImpl _repo;
  Timer? _debounceTimer;

  FindFriendsCubit(this._repo) : super(const FindFriendsState());

  Future<void> init() async {
    emit(
      state.copyWith(
        suggestedUsers: [],
        searchResults: [],
        pagination: null,
        searchPagination: null,
        searchQuery: '',
        isSearching: false,
      ),
    );
    await _fetchSuggestedUsers(page: 1);
  }

  Future<void> search(String query) async {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          isSearching: false,
          searchResults: [],
          searchPagination: null,
        ),
      );
      return;
    }

    emit(state.copyWith(searchQuery: query, isSearching: true));

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      emit(state.copyWith(searchResults: [], searchPagination: null));
      await _searchUsers(page: 1);
    });
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore) return;

    if (state.isSearching) {
      if (!state.hasMoreSearch) return;
      final nextPage = (state.searchPagination?.page ?? 1) + 1;
      await _searchUsers(page: nextPage, isLoadMore: true);
    } else {
      if (!state.hasMoreSuggested) return;
      final nextPage = (state.pagination?.page ?? 1) + 1;
      await _fetchSuggestedUsers(page: nextPage, isLoadMore: true);
    }
  }

  Future<void> followUser(String userId) async {
    final updatedFollowedIds = Set<String>.from(state.followedUserIds);
    final isCurrentlyFollowed = updatedFollowedIds.contains(userId);

    if (isCurrentlyFollowed) {
      updatedFollowedIds.remove(userId);
    } else {
      updatedFollowedIds.add(userId);
    }

    emit(state.copyWith(followedUserIds: updatedFollowedIds));

    await _repo.followUser(userId: userId);
  }

  Future<void> removeUser(String userId) async {
    // Optimistic removal
    final updatedSuggested = state.suggestedUsers
        .where((u) => u.id != userId)
        .toList();
    emit(state.copyWith(suggestedUsers: updatedSuggested));

    await _repo.removeUser(userId: userId);
  }

  Future<void> _fetchSuggestedUsers({
    required int page,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(isLoading: true));
    }

    final response = await _repo.getSuggestedUsers(page: page, limit: 10);

    if (response != null) {
      final newUsers = isLoadMore
          ? [...state.suggestedUsers, ...?response.suggestedUsers]
          : response.suggestedUsers ?? <NotificationSenderModel>[];

      emit(
        state.copyWith(
          suggestedUsers: newUsers,
          pagination: response.pagination,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false, isLoadingMore: false));
    }
  }

  Future<void> _searchUsers({
    required int page,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(isLoading: true));
    }

    final response = await _repo.searchUsers(
      page: page,
      limit: 20,
      search: state.searchQuery,
    );

    if (response != null) {
      final newUsers = isLoadMore
          ? [...state.searchResults, ...?response.suggestedUsers]
          : response.suggestedUsers ?? <NotificationSenderModel>[];

      emit(
        state.copyWith(
          searchResults: newUsers,
          searchPagination: response.pagination,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false, isLoadingMore: false));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/services/cache.dart';
import 'package:rightflair/feature/create_post/model/post.dart';
import 'package:rightflair/feature/search/model/request_search.dart';
import 'package:rightflair/feature/search/repository/search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final SearchRepository _repo;
  final CacheService _cacheService = CacheService();

  SearchCubit(this._repo) : super(SearchState.initial()) {
    loadRecentSearches();
  }

  /// Load recent searches from cache on initialization
  Future<void> loadRecentSearches() async {
    final searches = await _cacheService.getRecentSearches();
    emit(state.copyWith(recentSearches: searches));
  }

  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;

    final updatedSearches = List<String>.from(state.recentSearches);

    // Remove if already exists
    updatedSearches.remove(query);

    // Add to beginning
    updatedSearches.insert(0, query);

    // Keep only last 3 searches
    if (updatedSearches.length > 3) {
      updatedSearches.removeRange(3, updatedSearches.length);
    }

    emit(state.copyWith(recentSearches: updatedSearches));

    // Save to cache
    await _cacheService.saveRecentSearches(updatedSearches);
  }

  Future<void> removeRecentSearch(String query) async {
    final updatedSearches = List<String>.from(state.recentSearches);
    updatedSearches.remove(query);
    emit(state.copyWith(recentSearches: updatedSearches));

    // Update cache
    await _cacheService.saveRecentSearches(updatedSearches);
  }

  Future<void> clearRecentSearches() async {
    emit(state.copyWith(recentSearches: []));

    // Clear cache
    await _cacheService.clearRecentSearches();
  }

  Future<void> search(String query, {bool isNewSearch = true}) async {
    if (query.trim().isEmpty) return;

    // Minimum 2 character validation
    if (query.trim().length < 2) {
      emit(
        state.copyWith(
          errorMessage: 'Lütfen en az 2 karakter girin',
          searchResults: [],
        ),
      );
      return;
    }

    if (isNewSearch) {
      addRecentSearch(query);
      emit(
        state.copyWith(
          isLoading: true,
          searchResults: [],
          currentPage: 1,
          hasMoreResults: true,
          errorMessage: null,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final requestBody = RequestSearchModel(
        query: query,
        page: isNewSearch ? 1 : state.currentPage,
        limit: 20,
      );

      final response = await _repo.searchPosts(body: requestBody);

      if (response != null && response.posts != null) {
        final List<PostModel> newPosts = response.posts!;
        final hasMore = response.hasMore ?? (newPosts.length == 20);

        if (isNewSearch) {
          emit(
            state.copyWith(
              isLoading: false,
              searchResults: newPosts,
              hasMoreResults: hasMore,
              errorMessage: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              searchResults: [...state.searchResults, ...newPosts],
              currentPage: state.currentPage + 1,
              hasMoreResults: hasMore,
              errorMessage: null,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Search failed. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'An error occurred: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> loadMore(String query) async {
    if (!state.hasMoreResults || state.isLoading) return;
    await search(query, isNewSearch: false);
  }

  @override
  Future<void> close() {
    searchController.dispose();
    searchFocusNode.dispose();
    return super.close();
  }
}

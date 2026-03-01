import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/services/cache.dart';
import 'package:rightflair/feature/search/repository/search_repository.dart';

import '../../main/profile/model/pagination.dart';
import '../../share/model/share.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final SearchRepository _repo;
  final CacheService _cacheService = CacheService();
  Timer? _debounceTimer;

  SearchCubit(this._repo) : super(SearchState.initial()) {
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await _cacheService.getRecentSearches();
    emit(state.copyWith(recentSearches: searches));
  }

  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    final updatedSearches = List<String>.from(state.recentSearches);

    updatedSearches.remove(query);
    updatedSearches.insert(0, query);
    if (updatedSearches.length > 3) {
      updatedSearches.removeRange(3, updatedSearches.length);
    }

    emit(state.copyWith(recentSearches: updatedSearches));
    await _cacheService.saveRecentSearches(updatedSearches);
  }

  Future<void> removeRecentSearch(String query) async {
    final updatedSearches = List<String>.from(state.recentSearches);
    updatedSearches.remove(query);
    emit(state.copyWith(recentSearches: updatedSearches));
    await _cacheService.saveRecentSearches(updatedSearches);
  }

  Future<void> clearRecentSearches() async {
    emit(state.copyWith(recentSearches: []));
    await _cacheService.clearRecentSearches();
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().length < 2) return;
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      searchFocusNode.unfocus();
      addRecentSearch(query);
      search(query);
    });
  }

  void resetSearch() {
    _debounceTimer?.cancel();
    searchController.clear();
    emit(SearchState.initial().copyWith(recentSearches: state.recentSearches));
  }

  Future<void> search(String query) async {
    emit(state.copyWith(isLoading: true, hasSearched: true, results: []));
    final response = await _repo.searchUsers(
      query: query,
      pagination: PaginationModel().forSearchUsers(page: 1),
    );
    emit(
      state.copyWith(
        isLoading: false,
        results: response?.users ?? [],
        pagination: response?.pagination,
      ),
    );
  }

  Future<void> loadMore() async {
    final pagination = state.pagination;
    if (pagination == null || pagination.hasNext != true) return;
    if (state.isPaginating) return;

    final nextPage = (pagination.page ?? 1) + 1;
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    emit(state.copyWith(isPaginating: true));
    final response = await _repo.searchUsers(
      query: query,
      pagination: PaginationModel().forSearchUsers(page: nextPage),
    );

    final newUsers = response?.users ?? [];
    emit(
      state.copyWith(
        isPaginating: false,
        results: [...state.results, ...newUsers],
        pagination: response?.pagination,
      ),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    return super.close();
  }
}

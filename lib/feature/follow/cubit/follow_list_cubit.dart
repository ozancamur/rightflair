import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/enums/follow_list_type.dart';
import '../model/follow_list_request.dart';
import '../model/follow_list_response.dart';
import '../../user/repository/user_repository_impl.dart';
import 'follow_list_state.dart';

class FollowListCubit extends Cubit<FollowListState> {
  final UserRepositoryImpl _repo;
  Timer? _debounceTimer;

  FollowListCubit(this._repo) : super(const FollowListState());

  Future<void> init({required FollowListType listType, String? userId}) async {
    emit(
      state.copyWith(
        listType: listType,
        userId: userId,
        users: [],
        pagination: null,
        searchQuery: '',
      ),
    );
    await _fetchList(page: 1);
  }

  Future<void> search(String query) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      emit(state.copyWith(searchQuery: query, users: [], pagination: null));
      await _fetchList(page: 1);
    });
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    final nextPage = (state.pagination?.page ?? 0) + 1;
    await _fetchList(page: nextPage, isLoadMore: true);
  }

  Future<void> refresh() async {
    emit(state.copyWith(users: [], pagination: null));
    await _fetchList(page: 1);
  }

  Future<void> _fetchList({required int page, bool isLoadMore = false}) async {
    if (isLoadMore) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(isLoading: true));
    }

    final request = FollowListRequestModel(
      userId: state.userId,
      page: page,
      limit: 20,
      search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
    );

    FollowListResponseModel? response;
    if (state.listType == FollowListType.followers) {
      response = await _repo.getFollowersList(parameters: request);
    } else {
      response = await _repo.getFollowingList(parameters: request);
    }

    if (response != null) {
      final newUsers = isLoadMore
          ? [...state.users, ...?response.users]
          : response.users ?? [];

      emit(
        state.copyWith(
          users: newUsers,
          pagination: response.pagination,
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

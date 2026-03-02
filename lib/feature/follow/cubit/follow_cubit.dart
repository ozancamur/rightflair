import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/enums/follow_list_type.dart';
import '../model/follow_list_request.dart';
import '../model/follow_list_response.dart';
import '../model/follow_user.dart';
import '../repository/follow_repository_impl.dart';
import 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final FollowRepositoryImpl _repo;
  Timer? _debounceTimer;

  FollowCubit(this._repo) : super(const FollowState());

  Future<void> init({required FollowListType listType, String? userId}) async {
    emit(FollowState(activeTab: listType, userId: userId));
    await Future.wait([
      _fetchList(FollowListType.following, page: 1),
      _fetchList(FollowListType.followers, page: 1),
    ]);
  }

  void switchTab(FollowListType listType) {
    emit(state.copyWith(activeTab: listType));
  }

  Future<void> search(String query) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final activeTab = state.activeTab;
      if (activeTab == FollowListType.following) {
        emit(
          state.copyWith(
            followingData: state.followingData.copyWith(
              searchQuery: query,
              users: [],
              pagination: null,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            followersData: state.followersData.copyWith(
              searchQuery: query,
              users: [],
              pagination: null,
            ),
          ),
        );
      }
      await _fetchList(activeTab, page: 1);
    });
  }

  Future<void> loadMore() async {
    final activeTab = state.activeTab;
    final data = state.activeData;
    if (data.isLoadingMore || !data.hasMore) return;
    final nextPage = (data.pagination?.page ?? 0) + 1;
    await _fetchList(activeTab, page: nextPage, isLoadMore: true);
  }

  Future<void> refresh() async {
    final activeTab = state.activeTab;
    if (activeTab == FollowListType.following) {
      emit(
        state.copyWith(
          followingData: state.followingData.copyWith(
            users: [],
            pagination: null,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          followersData: state.followersData.copyWith(
            users: [],
            pagination: null,
          ),
        ),
      );
    }
    await _fetchList(activeTab, page: 1);
  }

  Future<void> _fetchList(
    FollowListType listType, {
    required int page,
    bool isLoadMore = false,
  }) async {
    final isFollowing = listType == FollowListType.following;
    final data = isFollowing ? state.followingData : state.followersData;

    // Emit loading state
    final loadingData = data.copyWith(
      isLoading: !isLoadMore,
      isLoadingMore: isLoadMore,
    );
    emit(
      isFollowing
          ? state.copyWith(followingData: loadingData)
          : state.copyWith(followersData: loadingData),
    );

    final request = FollowListRequestModel(
      userId: state.userId,
      page: page,
      limit: 20,
      search: data.searchQuery.isNotEmpty ? data.searchQuery : null,
    );

    FollowListResponseModel? response;
    if (listType == FollowListType.followers) {
      response = await _repo.getFollowersList(parameters: request);
    } else {
      response = await _repo.getFollowingList(parameters: request);
    }

    // Re-read data after async gap
    final currentData = isFollowing ? state.followingData : state.followersData;

    if (response != null) {
      final newUsers = isLoadMore
          ? [...currentData.users, ...?response.users]
          : response.users ?? <FollowUserModel>[];

      final updatedData = currentData.copyWith(
        users: newUsers,
        pagination: response.pagination,
        isLoading: false,
        isLoadingMore: false,
      );
      emit(
        isFollowing
            ? state.copyWith(followingData: updatedData)
            : state.copyWith(followersData: updatedData),
      );
    } else {
      final updatedData = currentData.copyWith(
        isLoading: false,
        isLoadingMore: false,
      );
      emit(
        isFollowing
            ? state.copyWith(followingData: updatedData)
            : state.copyWith(followersData: updatedData),
      );
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}

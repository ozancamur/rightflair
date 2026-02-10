import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/main/inbox/model/pagination_notification.dart';
import 'package:rightflair/feature/notifications/new_followers/repository/new_followers_repository_impl.dart';

import '../../../main/inbox/model/notification_sender.dart';
import '../model/new_follower.dart';

part 'new_followers_state.dart';

class NewFollowersCubit extends Cubit<NewFollowersState> {
  final NewFollowersRepositoryImpl _repo;
  NewFollowersCubit(this._repo) : super(NewFollowersState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoading: true));
    final notifications = await _repo.getNewFollowers(page: 1, limit: 6);
    final suggested = await _repo.getSuggestedUsers(page: 1, limit: 10);
    emit(
      state.copyWith(
        isLoading: false,
        notifications: notifications?.followers,
        pagination: notifications?.pagination,
        suggestedUsers: suggested?.suggestedUsers,
        paginationSuggested: suggested?.pagination,
      ),
    );
  }

  Future<void> loadMoreFollowers() async {
    if (state.isLoadingMoreFollowers || state.pagination?.hasNext != true) {
      return;
    }

    emit(state.copyWith(isLoadingMoreFollowers: true));

    final nextPage = (state.pagination?.page ?? 1) + 1;
    final newFollowers = await _repo.getNewFollowers(page: nextPage, limit: 6);

    if (newFollowers != null) {
      final updatedNotifications = <NewFollowerModel>[
        ...state.notifications ?? [],
        ...newFollowers.followers ?? [],
      ];

      emit(
        state.copyWith(
          isLoadingMoreFollowers: false,
          notifications: updatedNotifications,
          pagination: newFollowers.pagination,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMoreFollowers: false));
    }
  }

  Future<void> loadMoreSuggestedUsers() async {
    if (state.isLoadingMoreSuggested ||
        state.paginationSuggested?.hasNext != true) {
      return;
    }

    emit(state.copyWith(isLoadingMoreSuggested: true));

    final nextPage = (state.paginationSuggested?.page ?? 1) + 1;
    final newSuggested = await _repo.getSuggestedUsers(
      page: nextPage,
      limit: 10,
    );

    if (newSuggested != null) {
      final updatedSuggested = <NotificationSenderModel>[
        ...state.suggestedUsers ?? [],
        ...newSuggested.suggestedUsers ?? [],
      ];

      emit(
        state.copyWith(
          isLoadingMoreSuggested: false,
          suggestedUsers: updatedSuggested,
          paginationSuggested: newSuggested.pagination,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMoreSuggested: false));
    }
  }
}

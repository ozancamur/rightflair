import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/notifications/system_notifications/repository/system_notifications_repository_impl.dart';

import '../../../main/inbox/model/notification.dart';
import '../../../main/inbox/model/pagination_notification.dart';

part 'system_notifications_state.dart';

class SystemNotificationsCubit extends Cubit<SystemNotificationsState> {
  final SystemNotificationsRepositoryImpl _repo;
  SystemNotificationsCubit(this._repo) : super(SystemNotificationsState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoading: true));
    final response = await _repo.getSystemNotifications(page: 1);
    emit(
      state.copyWith(
        isLoading: false,
        notifications: response?.notifications ?? [],
        pagination: response?.pagination,
      ),
    );
  }

  Future<void> refresh() async {
    final response = await _repo.getSystemNotifications(page: 1);
    emit(
      state.copyWith(
        notifications: response?.notifications ?? [],
        pagination: response?.pagination,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.pagination?.hasNext != true) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = (state.pagination?.page ?? 1) + 1;
    final response = await _repo.getSystemNotifications(page: nextPage);

    if (response != null) {
      final updatedNotifications = <NotificationModel>[
        ...state.notifications ?? [],
        ...response.notifications ?? [],
      ];

      emit(
        state.copyWith(
          isLoadingMore: false,
          notifications: updatedNotifications,
          pagination: response.pagination,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}

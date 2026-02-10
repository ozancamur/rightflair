part of 'system_notifications_cubit.dart';

class SystemNotificationsState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final List<NotificationModel>? notifications;
  final PaginationNotificationModel? pagination;
  const SystemNotificationsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.notifications,
    this.pagination,
  });

  SystemNotificationsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<NotificationModel>? notifications,
    PaginationNotificationModel? pagination,
  }) {
    return SystemNotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      notifications: notifications ?? this.notifications,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    isLoadingMore,
    notifications ?? [],
    pagination ?? PaginationNotificationModel(),
  ];
}

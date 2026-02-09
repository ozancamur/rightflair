part of 'new_followers_cubit.dart';

class NewFollowersState extends Equatable {
  final bool isLoading;
  final List<NewFollowerModel>? notifications;
  final PaginationNotificationModel? pagination;

  final List<NotificationSenderModel>? suggestedUsers;
  final PaginationNotificationModel? paginationSuggested;

  const NewFollowersState({
    this.isLoading = false,
    this.notifications,
    this.pagination,
    this.suggestedUsers,
    this.paginationSuggested,
  });

  NewFollowersState copyWith({
    bool? isLoading,
    List<NewFollowerModel>? notifications,
    PaginationNotificationModel? pagination,
    List<NotificationSenderModel>? suggestedUsers,
    PaginationNotificationModel? paginationSuggested,
  }) {
    return NewFollowersState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      pagination: pagination ?? this.pagination,
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      paginationSuggested: paginationSuggested ?? this.paginationSuggested,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    notifications ?? [],
    pagination ?? PaginationNotificationModel(),
    suggestedUsers ?? [],
    paginationSuggested ?? PaginationNotificationModel(),
  ];
}

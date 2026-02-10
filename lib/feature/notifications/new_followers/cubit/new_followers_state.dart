part of 'new_followers_cubit.dart';

class NewFollowersState extends Equatable {
  final bool isLoading;
  final bool isLoadingMoreFollowers;
  final bool isLoadingMoreSuggested;
  final List<NewFollowerModel>? notifications;
  final PaginationNotificationModel? pagination;

  final List<NotificationSenderModel>? suggestedUsers;
  final PaginationNotificationModel? paginationSuggested;

  const NewFollowersState({
    this.isLoading = false,
    this.isLoadingMoreFollowers = false,
    this.isLoadingMoreSuggested = false,
    this.notifications,
    this.pagination,
    this.suggestedUsers,
    this.paginationSuggested,
  });

  NewFollowersState copyWith({
    bool? isLoading,
    bool? isLoadingMoreFollowers,
    bool? isLoadingMoreSuggested,
    List<NewFollowerModel>? notifications,
    PaginationNotificationModel? pagination,
    List<NotificationSenderModel>? suggestedUsers,
    PaginationNotificationModel? paginationSuggested,
  }) {
    return NewFollowersState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMoreFollowers:
          isLoadingMoreFollowers ?? this.isLoadingMoreFollowers,
      isLoadingMoreSuggested:
          isLoadingMoreSuggested ?? this.isLoadingMoreSuggested,
      notifications: notifications ?? this.notifications,
      pagination: pagination ?? this.pagination,
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      paginationSuggested: paginationSuggested ?? this.paginationSuggested,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    isLoadingMoreFollowers,
    isLoadingMoreSuggested,
    notifications ?? [],
    pagination ?? PaginationNotificationModel(),
    suggestedUsers ?? [],
    paginationSuggested ?? PaginationNotificationModel(),
  ];
}

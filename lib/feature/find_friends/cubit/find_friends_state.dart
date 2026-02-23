import 'package:equatable/equatable.dart';

import '../../main/inbox/model/notification_sender.dart';
import '../../main/inbox/model/pagination_notification.dart';

class FindFriendsState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final List<NotificationSenderModel> suggestedUsers;
  final List<NotificationSenderModel> searchResults;
  final PaginationNotificationModel? pagination;
  final PaginationNotificationModel? searchPagination;
  final String searchQuery;
  final bool isSearching;

  const FindFriendsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.suggestedUsers = const [],
    this.searchResults = const [],
    this.pagination,
    this.searchPagination,
    this.searchQuery = '',
    this.isSearching = false,
  });

  FindFriendsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<NotificationSenderModel>? suggestedUsers,
    List<NotificationSenderModel>? searchResults,
    PaginationNotificationModel? pagination,
    PaginationNotificationModel? searchPagination,
    String? searchQuery,
    bool? isSearching,
  }) {
    return FindFriendsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      searchResults: searchResults ?? this.searchResults,
      pagination: pagination ?? this.pagination,
      searchPagination: searchPagination ?? this.searchPagination,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  bool get hasMoreSuggested {
    return pagination?.hasNext == true;
  }

  bool get hasMoreSearch {
    return searchPagination?.hasNext == true;
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    suggestedUsers,
    searchResults,
    pagination,
    searchPagination,
    searchQuery,
    isSearching,
  ];
}

import 'package:equatable/equatable.dart';

import '../../../core/constants/enums/follow_list_type.dart';
import '../model/follow_user.dart';
import '../../main/profile/model/pagination.dart';

class FollowState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final List<FollowUserModel> users;
  final PaginationModel? pagination;
  final String searchQuery;
  final FollowListType listType;
  final String? userId;

  const FollowState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.users = const [],
    this.pagination,
    this.searchQuery = '',
    this.listType = FollowListType.followers,
    this.userId,
  });

  FollowState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<FollowUserModel>? users,
    PaginationModel? pagination,
    String? searchQuery,
    FollowListType? listType,
    String? userId,
  }) {
    return FollowState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      users: users ?? this.users,
      pagination: pagination ?? this.pagination,
      searchQuery: searchQuery ?? this.searchQuery,
      listType: listType ?? this.listType,
      userId: userId ?? this.userId,
    );
  }

  bool get hasMore {
    if (pagination == null) return false;
    return (pagination!.page ?? 1) < (pagination!.totalPages ?? 1);
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    users,
    pagination,
    searchQuery,
    listType,
    userId,
  ];
}

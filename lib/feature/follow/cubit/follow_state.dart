import 'package:equatable/equatable.dart';

import '../../../core/constants/enums/follow_list_type.dart';
import '../model/follow_user.dart';
import '../../main/profile/model/pagination.dart';

class FollowTabData extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final List<FollowUserModel> users;
  final PaginationModel? pagination;
  final String searchQuery;

  const FollowTabData({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.users = const [],
    this.pagination,
    this.searchQuery = '',
  });

  FollowTabData copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<FollowUserModel>? users,
    PaginationModel? pagination,
    String? searchQuery,
  }) {
    return FollowTabData(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      users: users ?? this.users,
      pagination: pagination ?? this.pagination,
      searchQuery: searchQuery ?? this.searchQuery,
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
  ];
}

class FollowState extends Equatable {
  final FollowTabData followingData;
  final FollowTabData followersData;
  final FollowListType activeTab;
  final String? userId;

  const FollowState({
    this.followingData = const FollowTabData(),
    this.followersData = const FollowTabData(),
    this.activeTab = FollowListType.followers,
    this.userId,
  });

  FollowState copyWith({
    FollowTabData? followingData,
    FollowTabData? followersData,
    FollowListType? activeTab,
    String? userId,
  }) {
    return FollowState(
      followingData: followingData ?? this.followingData,
      followersData: followersData ?? this.followersData,
      activeTab: activeTab ?? this.activeTab,
      userId: userId ?? this.userId,
    );
  }

  FollowTabData get activeData =>
      activeTab == FollowListType.following ? followingData : followersData;

  @override
  List<Object?> get props => [followingData, followersData, activeTab, userId];
}

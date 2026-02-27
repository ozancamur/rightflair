part of 'feed_bloc.dart';

class FeedState extends Equatable {
  final int currentTabIndex;
  final String? error;

  // ── Discover (tab 0) ──
  final bool isLoadingDiscover;
  final List<PostModel>? discoverPosts;
  final PaginationModel? discoverPagination;
  final bool isLoadingMoreDiscover;

  // ── Following (tab 1) ──
  final bool isLoadingFollowing;
  final List<PostModel>? followingPosts;
  final PaginationModel? followingPagination;
  final bool isLoadingMoreFollowing;

  // ── Friends (tab 2) ──
  final bool isLoadingFriends;
  final List<PostModel>? friendsPosts;
  final PaginationModel? friendsPagination;
  final bool isLoadingMoreFriends;
  final List<SuggestedUserModel>? suggestedUsers;
  final String? friendsFeedState; // "no_friends" | "feed_ended" | "has_more"

  // ── Comments ──
  final List<CommentModel>? comments;
  final bool isLoadingComments;

  const FeedState({
    this.currentTabIndex = 0,
    this.error,
    this.isLoadingDiscover = false,
    this.discoverPosts,
    this.discoverPagination,
    this.isLoadingMoreDiscover = false,
    this.isLoadingFollowing = false,
    this.followingPosts,
    this.followingPagination,
    this.isLoadingMoreFollowing = false,
    this.isLoadingFriends = false,
    this.friendsPosts,
    this.friendsPagination,
    this.isLoadingMoreFriends = false,
    this.suggestedUsers,
    this.friendsFeedState,
    this.comments,
    this.isLoadingComments = false,
  });

  /// Convenience getters — return data for the currently active tab
  bool get isLoading {
    switch (currentTabIndex) {
      case 0:
        return isLoadingDiscover;
      case 1:
        return isLoadingFollowing;
      case 2:
        return isLoadingFriends;
      default:
        return false;
    }
  }

  List<PostModel>? get posts {
    switch (currentTabIndex) {
      case 0:
        return discoverPosts;
      case 1:
        return followingPosts;
      case 2:
        return friendsPosts;
      default:
        return null;
    }
  }

  PaginationModel? get postPagination {
    switch (currentTabIndex) {
      case 0:
        return discoverPagination;
      case 1:
        return followingPagination;
      case 2:
        return friendsPagination;
      default:
        return null;
    }
  }

  bool get isLoadingMore {
    switch (currentTabIndex) {
      case 0:
        return isLoadingMoreDiscover;
      case 1:
        return isLoadingMoreFollowing;
      case 2:
        return isLoadingMoreFriends;
      default:
        return false;
    }
  }

  /// Tab-specific getters
  List<PostModel>? postsForTab(int index) {
    switch (index) {
      case 0:
        return discoverPosts;
      case 1:
        return followingPosts;
      case 2:
        return friendsPosts;
      default:
        return null;
    }
  }

  PaginationModel? paginationForTab(int index) {
    switch (index) {
      case 0:
        return discoverPagination;
      case 1:
        return followingPagination;
      case 2:
        return friendsPagination;
      default:
        return null;
    }
  }

  bool isLoadingForTab(int index) {
    switch (index) {
      case 0:
        return isLoadingDiscover;
      case 1:
        return isLoadingFollowing;
      case 2:
        return isLoadingFriends;
      default:
        return false;
    }
  }

  bool isLoadingMoreForTab(int index) {
    switch (index) {
      case 0:
        return isLoadingMoreDiscover;
      case 1:
        return isLoadingMoreFollowing;
      case 2:
        return isLoadingMoreFriends;
      default:
        return false;
    }
  }

  FeedState copyWith({
    int? currentTabIndex,
    String? error,
    bool? isLoadingDiscover,
    List<PostModel>? discoverPosts,
    PaginationModel? discoverPagination,
    bool? isLoadingMoreDiscover,
    bool? isLoadingFollowing,
    List<PostModel>? followingPosts,
    PaginationModel? followingPagination,
    bool? isLoadingMoreFollowing,
    bool? isLoadingFriends,
    List<PostModel>? friendsPosts,
    PaginationModel? friendsPagination,
    bool? isLoadingMoreFriends,
    List<SuggestedUserModel>? suggestedUsers,
    String? friendsFeedState,
    List<CommentModel>? comments,
    bool? isLoadingComments,
  }) {
    return FeedState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      error: error ?? this.error,
      isLoadingDiscover: isLoadingDiscover ?? this.isLoadingDiscover,
      discoverPosts: discoverPosts ?? this.discoverPosts,
      discoverPagination: discoverPagination ?? this.discoverPagination,
      isLoadingMoreDiscover:
          isLoadingMoreDiscover ?? this.isLoadingMoreDiscover,
      isLoadingFollowing: isLoadingFollowing ?? this.isLoadingFollowing,
      followingPosts: followingPosts ?? this.followingPosts,
      followingPagination: followingPagination ?? this.followingPagination,
      isLoadingMoreFollowing:
          isLoadingMoreFollowing ?? this.isLoadingMoreFollowing,
      isLoadingFriends: isLoadingFriends ?? this.isLoadingFriends,
      friendsPosts: friendsPosts ?? this.friendsPosts,
      friendsPagination: friendsPagination ?? this.friendsPagination,
      isLoadingMoreFriends: isLoadingMoreFriends ?? this.isLoadingMoreFriends,
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      friendsFeedState: friendsFeedState ?? this.friendsFeedState,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
    );
  }

  @override
  List<Object?> get props => [
    currentTabIndex,
    error,
    isLoadingDiscover,
    discoverPosts,
    discoverPagination,
    isLoadingMoreDiscover,
    isLoadingFollowing,
    followingPosts,
    followingPagination,
    isLoadingMoreFollowing,
    isLoadingFriends,
    friendsPosts,
    friendsPagination,
    isLoadingMoreFriends,
    suggestedUsers,
    friendsFeedState,
    comments,
    isLoadingComments,
  ];
}

import 'package:equatable/equatable.dart';

import '../../authentication/model/user.dart';
import '../../main/feed/models/user_with_stories.dart';
import '../../post/create_post/model/post.dart';
import '../../main/profile/model/pagination.dart';
import '../../main/profile/model/style_tags.dart';

class UserState extends Equatable {
  final bool isLoading;

  final UserModel user;
  final StyleTagsModel? tags;

  final List<PostModel>? posts;
  final PaginationModel? pagination;
  final bool isPostsLoading;
  final bool isLoadingMorePosts;

  final bool isFollowing;
  final bool isFollowLoading;
  final bool isNotificationEnabled;
  final UserWithStoriesModel? userStories;

  const UserState({
    this.isLoading = false,
    required this.user,
    this.tags,
    this.posts = const [],
    this.pagination,
    this.isPostsLoading = false,
    this.isLoadingMorePosts = false,
    this.isFollowing = false,
    this.isFollowLoading = false,
    this.isNotificationEnabled = false,
    this.userStories,
  });

  UserState copyWith({
    bool? isLoading,
    UserModel? user,
    StyleTagsModel? tags,
    List<PostModel>? posts,
    PaginationModel? pagination,
    bool? isPostsLoading,
    bool? isLoadingMorePosts,
    bool? isFollowing,
    bool? isFollowLoading,
    bool? isNotificationEnabled,
    UserWithStoriesModel? userStories,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      tags: tags ?? this.tags,
      posts: posts ?? this.posts,
      pagination: pagination ?? this.pagination,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      isLoadingMorePosts: isLoadingMorePosts ?? this.isLoadingMorePosts,
      isFollowing: isFollowing ?? this.isFollowing,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      userStories: userStories ?? this.userStories,
    );
  }

  UserState copyWithNullableStories({UserWithStoriesModel? userStories}) {
    return UserState(
      isLoading: isLoading,
      user: user,
      tags: tags,
      posts: posts,
      pagination: pagination,
      isPostsLoading: isPostsLoading,
      isLoadingMorePosts: isLoadingMorePosts,
      isFollowing: isFollowing,
      isFollowLoading: isFollowLoading,
      isNotificationEnabled: isNotificationEnabled,
      userStories: userStories,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    user,
    tags ?? StyleTagsModel(),
    posts ?? [],
    pagination ?? PaginationModel(),
    isPostsLoading,
    isLoadingMorePosts,
    isFollowing,
    isFollowLoading,
    isNotificationEnabled,
    userStories ?? UserWithStoriesModel(),
  ];
}

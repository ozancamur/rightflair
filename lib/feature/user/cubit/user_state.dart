import 'package:equatable/equatable.dart';

import '../../authentication/model/user.dart';
import '../../post/create_post/model/post.dart';
import '../../navigation/page/profile/model/pagination.dart';
import '../../navigation/page/profile/model/style_tags.dart';

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
  ];
}

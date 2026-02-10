part of 'feed_bloc.dart';

class FeedState extends Equatable {
  final int currentTabIndex;
  final String? error;
  final bool isLoading;

  final List<PostModel>? posts;
  final PaginationModel? postPagination;
  final bool isLoadingMore;

  final List<CommentModel>? comments;
  final bool isLoadingComments;

  final MyStoryModel? myStory;
  final List<UserWithStoriesModel>? stories;
  final PaginationModel? storyPagination;

  const FeedState({
    this.currentTabIndex = 0,
    this.error,
    this.isLoading = false,
    this.posts,
    this.postPagination,
    this.isLoadingMore = false,
    this.comments,
    this.isLoadingComments = false,
    this.myStory,
    this.stories,
    this.storyPagination,
  });

  FeedState copyWith({
    int? currentTabIndex,
    String? error,
    bool? isLoading,
    List<PostModel>? posts,
    PaginationModel? postPagination,
    bool? isLoadingMore,
    List<CommentModel>? comments,
    bool? isLoadingComments,
    MyStoryModel? myStory,
    List<UserWithStoriesModel>? stories,
    PaginationModel? storyPagination,
  }) {
    return FeedState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      postPagination: postPagination ?? this.postPagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      myStory: myStory ?? this.myStory,
      stories: stories ?? this.stories,
      storyPagination: storyPagination ?? this.storyPagination,
    );
  }

  @override
  List<Object?> get props => [
    currentTabIndex,
    error,
    isLoading,
    posts,
    postPagination,
    isLoadingMore,
    comments,
    isLoadingComments,
    myStory,
    stories,
    storyPagination,
  ];
}

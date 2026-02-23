part of 'story_view_cubit.dart';

class StoryViewState extends Equatable {
  final List<UserWithStoriesModel> stories;
  final int currentUserIndex;
  final int currentStoryIndex;
  final bool isPlaying;
  final int currentStoryDuration; // in seconds
  final bool shouldNavigateToNextUser;
  final bool shouldNavigateToPreviousUser;
  final bool shouldClose;
  // Viewers
  final bool isViewersLoading;
  final bool isViewersSheetOpen;
  final List<MyStoryViewersModel> viewers;
  final int totalViewCount;
  final StoryViewersPagination viewersPagination;

  const StoryViewState({
    this.stories = const [],
    this.currentUserIndex = 0,
    this.currentStoryIndex = 0,
    this.isPlaying = true,
    this.currentStoryDuration = 5,
    this.shouldNavigateToNextUser = false,
    this.shouldNavigateToPreviousUser = false,
    this.shouldClose = false,
    this.isViewersLoading = false,
    this.isViewersSheetOpen = false,
    this.viewers = const [],
    this.totalViewCount = 0,
    this.viewersPagination = const StoryViewersPagination(),
  });

  StoryViewState copyWith({
    List<UserWithStoriesModel>? stories,
    int? currentUserIndex,
    int? currentStoryIndex,
    bool? isPlaying,
    int? currentStoryDuration,
    bool? shouldNavigateToNextUser,
    bool? shouldNavigateToPreviousUser,
    bool? shouldClose,
    bool? isViewersLoading,
    bool? isViewersSheetOpen,
    List<MyStoryViewersModel>? viewers,
    int? totalViewCount,
    StoryViewersPagination? viewersPagination,
  }) {
    return StoryViewState(
      stories: stories ?? this.stories,
      currentUserIndex: currentUserIndex ?? this.currentUserIndex,
      currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      currentStoryDuration: currentStoryDuration ?? this.currentStoryDuration,
      shouldNavigateToNextUser:
          shouldNavigateToNextUser ?? this.shouldNavigateToNextUser,
      shouldNavigateToPreviousUser:
          shouldNavigateToPreviousUser ?? this.shouldNavigateToPreviousUser,
      shouldClose: shouldClose ?? this.shouldClose,
      isViewersLoading: isViewersLoading ?? this.isViewersLoading,
      isViewersSheetOpen: isViewersSheetOpen ?? this.isViewersSheetOpen,
      viewers: viewers ?? this.viewers,
      totalViewCount: totalViewCount ?? this.totalViewCount,
      viewersPagination: viewersPagination ?? this.viewersPagination,
    );
  }

  @override
  List<Object> get props => [
    stories,
    currentUserIndex,
    currentStoryIndex,
    isPlaying,
    currentStoryDuration,
    shouldNavigateToNextUser,
    shouldNavigateToPreviousUser,
    shouldClose,
    isViewersLoading,
    isViewersSheetOpen,
    viewers,
    totalViewCount,
    viewersPagination,
  ];
}

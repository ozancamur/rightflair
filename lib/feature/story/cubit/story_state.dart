part of 'story_cubit.dart';

class StoryState extends Equatable {
  final List<UserWithStoriesModel> stories;
  final int currentUserIndex;
  final int currentStoryIndex;
  final bool isPlaying;
  final int currentStoryDuration; // in seconds
  final bool shouldNavigateToNextUser;
  final bool shouldNavigateToPreviousUser;
  final bool shouldClose;

  const StoryState({
    this.stories = const [],
    this.currentUserIndex = 0,
    this.currentStoryIndex = 0,
    this.isPlaying = true,
    this.currentStoryDuration = 5,
    this.shouldNavigateToNextUser = false,
    this.shouldNavigateToPreviousUser = false,
    this.shouldClose = false,
  });

  StoryState copyWith({
    List<UserWithStoriesModel>? stories,
    int? currentUserIndex,
    int? currentStoryIndex,
    bool? isPlaying,
    int? currentStoryDuration,
    bool? shouldNavigateToNextUser,
    bool? shouldNavigateToPreviousUser,
    bool? shouldClose,
  }) {
    return StoryState(
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
  ];
}

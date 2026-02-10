import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/main/feed/models/user_with_stories.dart';
import 'package:rightflair/feature/story/story_view/repository/story_view_repository_impl.dart';

part 'story_view_state.dart';

class StoryViewCubit extends Cubit<StoryViewState> {
  Timer? _storyTimer;
  final StoryViewRepositoryImpl _repo;
  final Function(String storyId, String userId)? onStoryViewed;

  StoryViewCubit(this._repo, {this.onStoryViewed}) : super(StoryViewState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startStoryTimer();
    });
  }
  void init({
    required List<UserWithStoriesModel> stories,
    required int initialIndex,
  }) => emit(StoryViewState(stories: stories, currentUserIndex: initialIndex));

  void startStoryTimer() {
    _storyTimer?.cancel();

    final currentUser = state.stories[state.currentUserIndex];
    final currentStory = currentUser.stories?[state.currentStoryIndex];

    if (currentStory == null) return;

    // View story when it starts (only if not viewed)
    if (currentStory.id != null && currentStory.isViewed == false) {
      final userId = currentUser.user?.id;
      viewStory(sId: currentStory.id!, userId: userId);
    }

    final duration = Duration(seconds: currentStory.duration ?? 5);

    emit(
      state.copyWith(
        currentStoryDuration: duration.inSeconds,
        isPlaying: true,
        shouldNavigateToNextUser: false,
        shouldNavigateToPreviousUser: false,
        shouldClose: false,
      ),
    );

    _storyTimer = Timer(duration, () {
      nextStory();
    });
  }

  void pauseStory() {
    _storyTimer?.cancel();
    emit(state.copyWith(isPlaying: false));
  }

  void resumeStory() {
    final remaining = Duration(
      milliseconds: (state.currentStoryDuration * 1000 * (1 - 0.0)).toInt(),
    );

    emit(state.copyWith(isPlaying: true));

    _storyTimer?.cancel();
    _storyTimer = Timer(remaining, () {
      nextStory();
    });
  }

  void nextStory() {
    final currentUser = state.stories[state.currentUserIndex];
    final storiesCount = currentUser.stories?.length ?? 0;

    if (state.currentStoryIndex < storiesCount - 1) {
      // Next story of current user
      emit(state.copyWith(currentStoryIndex: state.currentStoryIndex + 1));
      startStoryTimer();
    } else {
      // Next user
      nextUser();
    }
  }

  void previousStory() {
    if (state.currentStoryIndex > 0) {
      emit(state.copyWith(currentStoryIndex: state.currentStoryIndex - 1));
      startStoryTimer();
    } else {
      previousUser();
    }
  }

  void nextUser() {
    if (state.currentUserIndex < state.stories.length - 1) {
      emit(
        state.copyWith(
          currentUserIndex: state.currentUserIndex + 1,
          currentStoryIndex: 0,
          shouldNavigateToNextUser: true,
        ),
      );
      startStoryTimer();
    } else {
      emit(state.copyWith(shouldClose: true));
    }
  }

  void previousUser() {
    if (state.currentUserIndex > 0) {
      final previousUser = state.stories[state.currentUserIndex - 1];
      final lastStoryIndex = (previousUser.stories?.length ?? 1) - 1;

      emit(
        state.copyWith(
          currentUserIndex: state.currentUserIndex - 1,
          currentStoryIndex: lastStoryIndex,
          shouldNavigateToPreviousUser: true,
        ),
      );
      startStoryTimer();
    }
  }

  void onTapLeft() {
    previousStory();
  }

  void onTapRight() {
    nextStory();
  }

  @override
  Future<void> close() {
    _storyTimer?.cancel();
    return super.close();
  }

  Future<void> viewStory({required String sId, String? userId}) async {
    await _repo.viewStory(sId: sId);
    if (onStoryViewed != null && userId != null) {
      onStoryViewed!(sId, userId);
    }
  }
}

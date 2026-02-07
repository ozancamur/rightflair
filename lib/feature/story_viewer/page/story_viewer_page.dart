import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rightflair/feature/navigation/page/feed/models/user_with_stories.dart';
import '../widgets/story_content.dart';
import '../widgets/story_progress_bar.dart';
import '../widgets/story_user_info.dart';

class StoryViewerPage extends StatefulWidget {
  final List<UserWithStoriesModel> stories;
  final int index;

  const StoryViewerPage({
    super.key,
    required this.stories,
    required this.index,
  });

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentUserIndex;
  int _currentStoryIndex = 0;
  Timer? _storyTimer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _currentUserIndex = widget.index;
    _pageController = PageController(initialPage: _currentUserIndex);
    _animationController = AnimationController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startStoryTimer();
    });
  }

  @override
  void dispose() {
    _storyTimer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startStoryTimer() {
    _storyTimer?.cancel();

    final currentUser = widget.stories[_currentUserIndex];
    final currentStory = currentUser.stories?[_currentStoryIndex];

    if (currentStory == null) return;

    // Default 5 seconds if duration not specified
    final duration = Duration(seconds: currentStory.duration ?? 5);

    _animationController.duration = duration;
    _animationController.forward(from: 0.0);

    _storyTimer = Timer(duration, () {
      _nextStory();
    });
  }

  void _pauseStory() {
    _storyTimer?.cancel();
    _animationController.stop();
  }

  void _resumeStory() {
    _animationController.forward();

    final remaining =
        _animationController.duration! * (1 - _animationController.value);
    _storyTimer?.cancel();
    _storyTimer = Timer(remaining, () {
      _nextStory();
    });
  }

  void _nextStory() {
    final currentUser = widget.stories[_currentUserIndex];
    final storiesCount = currentUser.stories?.length ?? 0;

    if (_currentStoryIndex < storiesCount - 1) {
      // Next story of current user
      setState(() {
        _currentStoryIndex++;
      });
      _startStoryTimer();
    } else {
      // Next user
      _nextUser();
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _startStoryTimer();
    } else {
      _previousUser();
    }
  }

  void _nextUser() {
    if (_currentUserIndex < widget.stories.length - 1) {
      setState(() {
        _currentUserIndex++;
        _currentStoryIndex = 0;
      });
      _pageController.animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousUser() {
    if (_currentUserIndex > 0) {
      final previousUser = widget.stories[_currentUserIndex - 1];
      final lastStoryIndex = (previousUser.stories?.length ?? 1) - 1;

      setState(() {
        _currentUserIndex--;
        _currentStoryIndex = lastStoryIndex;
      });
      _pageController.animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer();
    }
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      _previousStory();
    } else if (dx > 2 * screenWidth / 3) {
      _nextStory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, context),
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.of(context).pop();
          }
        },
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.stories.length,
          onPageChanged: (index) {
            setState(() {
              _currentUserIndex = index;
              _currentStoryIndex = 0;
            });
            _startStoryTimer();
          },
          itemBuilder: (context, userIndex) {
            final userStories = widget.stories[userIndex];

            if (userIndex != _currentUserIndex) {
              return const SizedBox.shrink();
            }

            return Stack(
              children: [
                // Story Content
                StoryContent(story: userStories.stories?[_currentStoryIndex]),

                // Gradient overlay for better text visibility
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // User info and progress bars
                SafeArea(
                  child: Column(
                    children: [
                      // Progress bars
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: StoryProgressBar(
                          storiesCount: userStories.stories?.length ?? 0,
                          currentIndex: _currentStoryIndex,
                          animationController: _animationController,
                        ),
                      ),

                      // User info
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: StoryUserInfo(
                          user: userStories.user,
                          createdAt: userStories
                              .stories?[_currentStoryIndex]
                              .createdAt,
                          onClose: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

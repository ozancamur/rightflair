import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/feature/navigation/page/feed/bloc/feed_bloc.dart';
import 'package:rightflair/feature/navigation/page/feed/models/user_with_stories.dart';
import 'package:rightflair/feature/story/cubit/story_cubit.dart';
import 'package:rightflair/feature/story/repository/story_repository_impl.dart';
import '../widgets/story_content.dart';
import '../widgets/story_progress_bar.dart';
import '../widgets/story_user_info.dart';

class StoryPage extends StatefulWidget {
  final List<UserWithStoriesModel> stories;
  final int index;

  const StoryPage({super.key, required this.stories, required this.index});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateAnimation(int duration, bool isPlaying) {
    _animationController.duration = Duration(seconds: duration);
    if (isPlaying) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedBloc = context.read<FeedBloc>();
    
    return BlocProvider(
      create: (context) =>
          StoryCubit(
            StoryRepositoryImpl(),
            onStoryViewed: (storyId, userId) {
              feedBloc.add(StoryViewedEvent(
                storyId: storyId,
                userId: userId,
              ));
            },
          )..init(stories: widget.stories, initialIndex: widget.index),
      child: BlocConsumer<StoryCubit, StoryState>(
        listener: (context, state) {
          if (state.shouldClose) {
            context.pop();
            return;
          }

          if (state.shouldNavigateToNextUser ||
              state.shouldNavigateToPreviousUser) {
            _pageController.animateToPage(
              state.currentUserIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }

          _updateAnimation(state.currentStoryDuration, state.isPlaying);
        },
        builder: (context, state) {
          final cubit = context.read<StoryCubit>();

          return Scaffold(
            backgroundColor: Colors.black,
            body: GestureDetector(
              onTapDown: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                final dx = details.globalPosition.dx;

                if (dx < screenWidth / 3) {
                  cubit.onTapLeft();
                } else if (dx > 2 * screenWidth / 3) {
                  cubit.onTapRight();
                }
              },
              onLongPressStart: (_) => cubit.pauseStory(),
              onLongPressEnd: (_) => cubit.resumeStory(),
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  Navigator.of(context).pop();
                }
              },
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.stories.length,
                onPageChanged: (index) {
                  // Page controller is controlled by cubit
                },
                itemBuilder: (context, userIndex) {
                  final userStories = state.stories[userIndex];

                  if (userIndex != state.currentUserIndex) {
                    return const SizedBox.shrink();
                  }

                  return Stack(
                    children: [
                      // Story Content
                      StoryContent(
                        story: userStories.stories?[state.currentStoryIndex],
                      ),

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
                                currentIndex: state.currentStoryIndex,
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
                                    .stories?[state.currentStoryIndex]
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
        },
      ),
    );
  }
}

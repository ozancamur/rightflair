import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/feature/main/feed/models/user_with_stories.dart';
import 'package:rightflair/feature/story/story_view/cubit/story_view_cubit.dart';
import 'package:rightflair/feature/story/story_view/repository/story_view_repository_impl.dart';
import '../widgets/story_content.dart';
import '../widgets/story_progress_bar.dart';
import '../widgets/story_user_info.dart';

class StoryViewPage extends StatefulWidget {
  final bool isMyStory;
  final List<UserWithStoriesModel> stories;
  final int index;

  const StoryViewPage({
    super.key,
    required this.stories,
    required this.index,
    required this.isMyStory,
  });

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage>
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
    return BlocProvider(
      create: (context) => StoryViewCubit(
        StoryViewRepositoryImpl(),
        onStoryViewed: (storyId, userId) {},
      )..init(stories: widget.stories, initialIndex: widget.index),
      child: BlocConsumer<StoryViewCubit, StoryViewState>(
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
          final cubit = context.read<StoryViewCubit>();

          return _body(context, cubit, state);
        },
      ),
    );
  }

  Scaffold _body(
    BuildContext context,
    StoryViewCubit cubit,
    StoryViewState state,
  ) {
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
        child: _page(state),
      ),
    );
  }

  PageView _page(StoryViewState state) {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.stories.length,
      onPageChanged: (index) {
        // Page controller is controlled by cubit
      },
      itemBuilder: (context, userIndex) {
        final story = state.stories[userIndex];

        if (userIndex != state.currentUserIndex) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            // Story Content
            StoryContent(story: story.stories?[state.currentStoryIndex]),

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
                    colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  ),
                ),
              ),
            ),

            // User info and progress bars
            SafeArea(
              child: Column(
                children: [
                  // Progress bars
                  _progress(story, state),
                  // User info
                  _info(story, state, context),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Padding _progress(UserWithStoriesModel story, StoryViewState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: StoryProgressBar(
        storiesCount: story.stories?.length ?? 0,
        currentIndex: state.currentStoryIndex,
        animationController: _animationController,
      ),
    );
  }

  Padding _info(
    UserWithStoriesModel story,
    StoryViewState state,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: StoryUserInfo(
        user: story.user,
        createdAt: story.stories?[state.currentStoryIndex].createdAt,
        onClose: () => Navigator.of(context).pop(),
        isMyStory: widget.isMyStory,
        onDelete: widget.isMyStory
            ? () {
                final currentStory = story.stories?[state.currentStoryIndex];
                if (currentStory?.id != null) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Hikayeyi Sil'),
                      content: const Text(
                        'Bu hikayeyi silmek istediğinize emin misiniz?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('İptal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Sil',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            : null,
      ),
    );
  }
}

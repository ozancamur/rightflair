import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/feature/main/feed/models/user_with_stories.dart';
import 'package:rightflair/feature/story/story_view/cubit/story_view_cubit.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/feature/story/story_view/repository/story_view_repository_impl.dart';
import '../widgets/story_content.dart';
import '../widgets/story_progress_bar.dart';
import '../widgets/story_user_info.dart';
import '../widgets/story_viewer_count.dart';
import '../widgets/story_viewers_sheet.dart';

class StoryViewPage extends StatefulWidget {
  final bool isMyStory;
  final List<UserWithStoriesModel> stories;
  final int index;
  final VoidCallback? onStoryDeleted;
  final Function(String storyId, String userId)? onStoryViewed;

  const StoryViewPage({
    super.key,
    required this.stories,
    required this.index,
    required this.isMyStory,
    this.onStoryDeleted,
    this.onStoryViewed,
  });

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;

  // Drag-to-dismiss state
  double _dragOffset = 0.0;
  bool _isDraggingDown = false;
  bool _isLongPressing = false;

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
        onStoryViewed: widget.onStoryViewed,
        onStoryDeleted: widget.onStoryDeleted,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final progress = (_dragOffset / (screenHeight * 0.4)).clamp(0.0, 1.0);
    final scale = 1.0 - (progress * 0.4);
    final borderRadius = progress * 24.0;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTapDown: (details) {
          if (_isDraggingDown) return;
          final screenWidth = MediaQuery.of(context).size.width;
          final dx = details.globalPosition.dx;

          if (dx < screenWidth / 3) {
            cubit.onTapLeft();
          } else if (dx > 2 * screenWidth / 3) {
            cubit.onTapRight();
          }
        },
        onLongPressStart: (_) {
          _isLongPressing = true;
          cubit.pauseStory();
        },
        onLongPressMoveUpdate: (details) {
          if (!_isLongPressing) return;
          final dy = details.offsetFromOrigin.dy;
          if (dy > 0) {
            setState(() {
              _isDraggingDown = true;
              _dragOffset = dy;
            });
          } else if (_isDraggingDown) {
            setState(() {
              _dragOffset = 0.0;
            });
          }
        },
        onLongPressEnd: (_) {
          if (_isDraggingDown) {
            if (_dragOffset > screenHeight * 0.6) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                _dragOffset = 0.0;
                _isDraggingDown = false;
              });
              cubit.resumeStory();
            }
          } else {
            cubit.resumeStory();
          }
          _isLongPressing = false;
        },
        onVerticalDragStart: (_) {
          if (_isLongPressing) return;
          cubit.pauseStory();
        },
        onVerticalDragUpdate: (details) {
          if (_isLongPressing) return;
          final dy = details.primaryDelta ?? 0;
          if (_dragOffset + dy > 0) {
            setState(() {
              _isDraggingDown = true;
              _dragOffset = (_dragOffset + dy).clamp(0.0, screenHeight);
            });
          }
        },
        onVerticalDragEnd: (details) {
          if (_isLongPressing) return;
          final velocity = details.primaryVelocity ?? 0;

          if (_isDraggingDown &&
              (_dragOffset > screenHeight * 0.6 || velocity > 1500)) {
            Navigator.of(context).pop();
          } else if (_isDraggingDown) {
            setState(() {
              _dragOffset = 0.0;
              _isDraggingDown = false;
            });
            cubit.resumeStory();
          } else if (velocity < -300 && widget.isMyStory) {
            cubit.resumeStory();
            _showViewersSheet(context, cubit);
          } else {
            cubit.resumeStory();
          }
        },
        child: Stack(
          children: [
            // Dark overlay behind story content
            Positioned.fill(
              child: ColoredBox(color: Colors.black.withOpacity(opacity)),
            ),
            AnimatedContainer(
              duration: _isDraggingDown
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              transform: Matrix4.identity()
                ..translate(0.0, _dragOffset)
                ..scale(scale, scale),
              transformAlignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: _page(state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showViewersSheet(BuildContext context, StoryViewCubit cubit) {
    cubit.openViewersSheet();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const StoryViewersSheet()),
    ).whenComplete(() {
      cubit.closeViewersSheet();
    });
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

            // Gradient overlay for better text visibility (top)
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

            // Bottom gradient for viewer count visibility (only for own stories)
            if (widget.isMyStory)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
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
                  _progress(story, state),
                  // User info
                  _info(story, state, context),
                ],
              ),
            ),

            // Viewer count (bottom-left, only for own stories)
            if (widget.isMyStory)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: StoryViewerCount(
                      viewCount:
                          story.stories?[state.currentStoryIndex].viewCount ??
                          0,
                      onTap: () {
                        final cubit = context.read<StoryViewCubit>();
                        _showViewersSheet(context, cubit);
                      },
                    ),
                  ),
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
                  final cubit = context.read<StoryViewCubit>();
                  cubit.pauseStory();
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(AppStrings.STORY_DELETE_TITLE.tr()),
                      content: Text(AppStrings.STORY_DELETE_MESSAGE.tr()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            cubit.resumeStory();
                          },
                          child: Text(AppStrings.STORY_DELETE_CANCEL.tr()),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            final deleted = await cubit.deleteStory(
                              storyId: currentStory!.id!,
                            );
                            if (!deleted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppStrings.STORY_DELETE_FAILED.tr(),
                                  ),
                                ),
                              );
                              cubit.resumeStory();
                            }
                          },
                          child: Text(
                            AppStrings.STORY_DELETE_DELETE.tr(),
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

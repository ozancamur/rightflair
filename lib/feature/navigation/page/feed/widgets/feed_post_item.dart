import 'package:flutter/material.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';
import '../models/feed_post_model.dart';
import 'post/post_actions.dart';
import 'post/post_shadow.dart';
import 'post/post_user_info.dart';

enum SwipeDirection { left, right, none }

class FeedPostItem extends StatefulWidget {
  final FeedPostModel post;
  final void Function(String postId, SwipeDirection direction)? onSwipeComplete;

  const FeedPostItem({super.key, required this.post, this.onSwipeComplete});

  @override
  State<FeedPostItem> createState() => _FeedPostItemState();
}

class _FeedPostItemState extends State<FeedPostItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;

    if (_dragOffset.dx > threshold) {
      // Sağa kaydırma - Beğenme
      _swipeRight();
    } else if (_dragOffset.dx < -threshold) {
      // Sola kaydırma - Beğenmeme
      _swipeLeft();
    } else {
      // Yerine geri dön
      _resetPosition();
    }
  }

  void _swipeRight() {
    // Beğenme animasyonu
    final screenWidth = MediaQuery.of(context).size.width;

    _animationController.reset();
    _animation =
        Tween<Offset>(
          begin: _dragOffset,
          end: Offset(screenWidth * 1.5, _dragOffset.dy),
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward().then((_) {
      widget.onSwipeComplete?.call(widget.post.id, SwipeDirection.right);
      _resetCard();
    });
  }

  void _swipeLeft() {
    // Beğenmeme animasyonu
    final screenWidth = MediaQuery.of(context).size.width;

    _animationController.reset();
    _animation =
        Tween<Offset>(
          begin: _dragOffset,
          end: Offset(-screenWidth * 1.5, _dragOffset.dy),
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward().then((_) {
      widget.onSwipeComplete?.call(widget.post.id, SwipeDirection.left);
      _resetCard();
    });
  }

  void _resetPosition() {
    _animationController.reset();
    _animation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward().then((_) {
      _resetCard();
    });
  }

  void _resetCard() {
    setState(() {
      _dragOffset = Offset.zero;
      _animationController.reset();
    });
  }

  double _getRotation(Offset offset, BuildContext context) {
    final rotationStrength = context.width * 0.00075;
    return offset.dx / rotationStrength;
  }

  double _getOpacity(Offset offset, BuildContext context) {
    final opacityThreshold = context.width * 0.25;
    final opacity = 1 - (offset.dx.abs() / opacityThreshold).clamp(0.0, 0.5);
    return opacity;
  }

  @override
  Widget build(BuildContext context) {
    final currentOffset = _animationController.isAnimating
        ? _animation.value
        : _dragOffset;

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          // Beğen/Beğenme göstergeleri
          if (_isDragging)
            Positioned.fill(
              child: Stack(
                children: [
                  // Beğen göstergesi (sağ taraf)
                  if (_dragOffset.dx > context.width * 0.125)
                    Positioned(
                      top: context.height * 0.15,
                      right: context.width * 0.1,
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.width * 0.05,
                            vertical: context.height * 0.012,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppDarkColors.GREEN,
                              width: context.width * 0.01,
                            ),
                            borderRadius: BorderRadius.circular(context.width * 0.02),
                          ),
                          child: TextComponent(
                            text: AppStrings.POST_LIKED,
                            size: FontSizeConstants.XXX_HUGE,
                            color: AppDarkColors.GREEN,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Beğenmeme göstergesi (sol taraf)
                  if (_dragOffset.dx < -context.width * 0.125)
                    Positioned(
                      top: context.height * 0.15,
                      left: context.width * 0.1,
                      child: Transform.rotate(
                        angle: 0.3,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.width * 0.05,
                            vertical: context.height * 0.012,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppDarkColors.RED,
                              width: context.width * 0.01,
                            ),
                            borderRadius: BorderRadius.circular(context.width * 0.02),
                          ),
                          child: TextComponent(
                            text: AppStrings.POST_DISLIKED,
                            size: FontSizeConstants.XXX_HUGE,
                            color: AppDarkColors.RED,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          // Ana kart
          Transform.translate(
            offset: currentOffset,
            child: Transform.rotate(
              angle: _getRotation(currentOffset, context),
              child: Opacity(
                opacity: _getOpacity(currentOffset, context),
                child: Container(
                  height: context.height,
                  width: context.width,
                  decoration: BoxDecoration(
                    color: AppDarkColors.PRIMARY,
                    borderRadius: BorderRadius.circular(context.width * 0.06),
                    image: DecorationImage(
                      image: NetworkImage(widget.post.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      const PostShadowWidget(),
                      const PostUserInfoWidget(),
                      PostActionsWidget(
                        comment: widget.post.commentCount,
                        like: widget.post.likeCount,
                        share: widget.post.shareCount,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

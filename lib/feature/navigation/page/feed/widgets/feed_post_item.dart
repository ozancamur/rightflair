import 'package:flutter/material.dart';

import '../../../../../core/extensions/context.dart';
import '../models/feed_post_model.dart';
import '../models/swipe_direction.dart';
import 'post/post_actions.dart';
import 'post/post_shadow.dart';
import 'post/post_user_info.dart';

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

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
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
    // Tinder/Bumble gibi yumuşak rotasyon (max 15 derece)
    const maxRotation = 0.26; // ~15 derece (radyan cinsinden)
    final screenWidth = context.width;
    final rotation = (offset.dx / screenWidth) * maxRotation;
    return rotation.clamp(-maxRotation, maxRotation);
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
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: _post(currentOffset, context),
    );
  }

  Transform _post(Offset currentOffset, BuildContext context) {
    return Transform.translate(
      offset: currentOffset,
      child: Transform.rotate(
        angle: _getRotation(currentOffset, context),
        child: Opacity(
          opacity: _getOpacity(currentOffset, context),
          child: Container(
            height: context.height,
            width: context.width,
            decoration: BoxDecoration(
              color: context.colors.primary,
              borderRadius: BorderRadius.circular(context.width * 0.06),
              image: DecorationImage(
                image: NetworkImage(widget.post.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (currentOffset.dx > 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            context.colors.scrim.withOpacity(.35),
                            context.colors.scrim.withOpacity(0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          context.width * 0.06,
                        ),
                      ),
                    ),
                  ),
                if (currentOffset.dx < 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            context.colors.error.withOpacity(.35),
                            context.colors.error.withOpacity(0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          context.width * 0.06,
                        ),
                      ),
                    ),
                  ),
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
    );
  }
}

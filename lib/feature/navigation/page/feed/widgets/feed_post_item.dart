import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context.dart';
import '../../../../comments/page/dialog_comments.dart';
import '../../../../create_post/model/post.dart';
import '../bloc/feed_bloc.dart';
import '../models/swipe_direction.dart';
import 'post/post_actions.dart';
import 'post/post_image.dart';
import 'post/post_shadow.dart';
import 'post/post_user_info.dart';

class FeedPostItem extends StatefulWidget {
  final PostModel post;
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
    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addListener(() {
          setState(() {});
        });
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
      _swipeRight();
    } else if (_dragOffset.dx < -threshold) {
      _swipeLeft();
    } else {
      _resetPosition();
    }
  }

  void _swipeRight() {
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
      widget.onSwipeComplete?.call(widget.post.id ?? "", SwipeDirection.right);
      _resetCard();
    });
  }

  void _swipeLeft() {
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
      widget.onSwipeComplete?.call(widget.post.id ?? "", SwipeDirection.left);
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
    const maxRotation = 0.26;
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
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PostImageWidget(url: widget.post.postImageUrl ?? ""),
                if (currentOffset.dx > 0) _right(context),

                if (currentOffset.dx < 0) _left(context),

                const PostShadowWidget(),

                const PostUserInfoWidget(),
                PostActionsWidget(
                  comment: widget.post.commentsCount ?? 0,
                  saved: widget.post.savesCount ?? 0,
                  shared: widget.post.sharesCount ?? 0,
                  postId: widget.post.id ?? "",
                  onComment: () =>
                      dialogComments(context, postId: widget.post.id ?? ""),
                  onSave: () => context.read<FeedBloc>().add(
                    SavePostEvent(postId: widget.post.id),
                  ),
                  onShare: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _right(BuildContext context) {
    return Positioned.fill(
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
          borderRadius: BorderRadius.circular(context.width * 0.06),
        ),
      ),
    );
  }

  Positioned _left(BuildContext context) {
    return Positioned.fill(
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
          borderRadius: BorderRadius.circular(context.width * 0.06),
        ),
      ),
    );
  }
}

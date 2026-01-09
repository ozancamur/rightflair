import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../core/components/post_icon_button.dart';
import 'post/post_shadow.dart';
import 'post/post_user_info.dart';

class FeedPostItem extends StatefulWidget {
  const FeedPostItem({super.key});

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
    _animation =
        Tween<Offset>(
          begin: _dragOffset,
          end: Offset(screenWidth * 1.5, _dragOffset.dy),
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward().then((_) {
      // Beğenme işlemi burada yapılır
      print('Beğenildi! ❤️');
      _resetCard();
    });
  }

  void _swipeLeft() {
    // Beğenmeme animasyonu
    final screenWidth = MediaQuery.of(context).size.width;
    _animation =
        Tween<Offset>(
          begin: _dragOffset,
          end: Offset(-screenWidth * 1.5, _dragOffset.dy),
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward().then((_) {
      // Beğenmeme işlemi burada yapılır
      print('Beğenilmedi! 👎');
      _resetCard();
    });
  }

  void _resetPosition() {
    _animation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
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

  double _getRotation() {
    const rotationStrength = 0.0003;
    return _dragOffset.dx * rotationStrength;
  }

  double _getOpacity() {
    const opacityThreshold = 100.0;
    final opacity =
        1 - (_dragOffset.dx.abs() / opacityThreshold).clamp(0.0, 0.5);
    return opacity;
  }

  @override
  Widget build(BuildContext context) {
    final String url =
        "https://static.ticimax.cloud/cdn-cgi/image/width=851,quality=99/6601//uploads/editoruploads/smart-casual-kombinleri-3.jpg";

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
                  if (_dragOffset.dx > 50)
                    Positioned(
                      top: context.height * 0.15,
                      right: context.width * 0.1,
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'BEĞENDİM',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Beğenmeme göstergesi (sol taraf)
                  if (_dragOffset.dx < -50)
                    Positioned(
                      top: context.height * 0.15,
                      left: context.width * 0.1,
                      child: Transform.rotate(
                        angle: 0.3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'BEĞENMEDİM',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
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
              angle: _getRotation(),
              child: Opacity(
                opacity: _getOpacity(),
                child: Container(
                  height: context.height,
                  width: context.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      const PostShadowWidget(),
                      const PostUserInfoWidget(),
                      Positioned(
                        right: context.width * .04,
                        bottom: context.width * .08,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: context.height * .01,
                          children: [
                            PostIconButtonComponent(
                              onTap: () {},
                              icon: AppIcons.MESSAGE_FILLED,
                              value: 234,
                            ),
                            PostIconButtonComponent(
                              onTap: () {},
                              icon: AppIcons.SAVE_FILLED,
                              value: 53,
                            ),
                            PostIconButtonComponent(
                              onTap: () {},
                              icon: AppIcons.SHARE_FILLED,
                              value: 27,
                            ),
                          ],
                        ),
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

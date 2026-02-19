import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/services/cache.dart';

class FeedSwipeOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const FeedSwipeOverlay({super.key, required this.onDismiss});

  static const String _cacheKey = 'feed_swipe_overlay_shown';

  /// Returns true if the overlay has already been shown (should NOT be displayed).
  static Future<bool> hasBeenShown() async {
    final cache = CacheService();
    final value = await cache.get(_cacheKey);
    return value == true;
  }

  /// Marks the overlay as shown so it never appears again.
  static Future<void> markAsShown() async {
    final cache = CacheService();
    await cache.set(_cacheKey, true);
  }

  @override
  State<FeedSwipeOverlay> createState() => _FeedSwipeOverlayState();
}

class _FeedSwipeOverlayState extends State<FeedSwipeOverlay>
    with TickerProviderStateMixin {
  late AnimationController _arrowController;
  late AnimationController _fadeController;
  late Animation<double> _arrowAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // Arrow horizontal oscillation
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _arrowAnimation = Tween<double>(begin: -30, end: 30).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
    _arrowController.repeat(reverse: true);

    // Auto dismiss after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _fadeController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: _dismiss,
        child: Container(
          color: Colors.black.withValues(alpha: 0.55),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildArrows(context),
                const SizedBox(height: 24),
                _buildText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArrows(BuildContext context) {
    return AnimatedBuilder(
      animation: _arrowAnimation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left arrow
            Transform.translate(
              offset: Offset(-_arrowAnimation.value.abs(), 0),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white.withValues(alpha: 0.85),
                size: 36,
              ),
            ),
            SizedBox(width: context.width * 0.25),
            // Right arrow
            Transform.translate(
              offset: Offset(_arrowAnimation.value.abs(), 0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.85),
                size: 36,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'feed.swipeToReact'.tr(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

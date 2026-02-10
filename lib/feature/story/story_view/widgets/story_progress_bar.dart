import 'package:flutter/material.dart';

class StoryProgressBar extends StatelessWidget {
  final int storiesCount;
  final int currentIndex;
  final AnimationController animationController;

  const StoryProgressBar({
    super.key,
    required this.storiesCount,
    required this.currentIndex,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(storiesCount, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: _ProgressIndicator(
              isActive: index == currentIndex,
              isCompleted: index < currentIndex,
              animationController: animationController,
            ),
          ),
        );
      }),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final AnimationController animationController;

  const _ProgressIndicator({
    required this.isActive,
    required this.isCompleted,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5),
        color: Colors.white.withOpacity(0.3),
      ),
      child: isCompleted
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.5),
                color: Colors.white,
              ),
            )
          : isActive
          ? AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: animationController.value,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.circular(1.5),
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}

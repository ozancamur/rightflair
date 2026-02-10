import 'package:flutter/material.dart';

import 'swipeable_post_stack.dart';

class FeedTabViews extends StatelessWidget {
  const FeedTabViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SwipeablePostStack(tabIndex: 0),
          SwipeablePostStack(tabIndex: 1),
          SwipeablePostStack(tabIndex: 2),
        ],
      ),
    );
  }
}

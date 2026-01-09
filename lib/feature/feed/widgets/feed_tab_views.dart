import 'package:flutter/material.dart';

import 'feed_post_item.dart';

class FeedTabViews extends StatelessWidget {
  const FeedTabViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Center(child: FeedPostItem()),
          Center(
            child: Text(
              'Content for Tab 2',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              'Content for Tab 3',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

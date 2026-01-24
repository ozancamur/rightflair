import 'package:flutter/material.dart';

import '../../../../../core/components/profile/profile_post_grid.dart';
import '../../../../../core/extensions/context.dart';
import '../../../../create_post/model/post.dart';

class ProfileTabViewsWidget extends StatelessWidget {
  final List<PostModel>? posts;
  final bool isPostsLoading;
  final List<PostModel>? saves;
  final bool isSavesLoading;
  final List<PostModel>? drafts;
  final bool isDraftsLoading;
  const ProfileTabViewsWidget({
    super.key,
    required this.posts,
    required this.saves,
    required this.drafts,
    required this.isPostsLoading,
    required this.isSavesLoading,
    required this.isDraftsLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.55,
      child: TabBarView(
        children: [
          ProfilePostGridComponent(posts: posts, isLoading: isPostsLoading),
          ProfilePostGridComponent(posts: saves, isLoading: isSavesLoading),
          ProfilePostGridComponent(posts: drafts, isLoading: isDraftsLoading),
        ],
      ),
    );
  }
}

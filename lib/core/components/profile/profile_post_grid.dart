import 'package:flutter/material.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../feature/post/create_post/model/post.dart';
import 'profile_non_post.dart';
import 'profile_post_grid_item.dart';

class ProfilePostGridComponent extends StatelessWidget {
  final List<PostModel>? posts;
  final bool isLoading;
  final bool isDraft;
  const ProfilePostGridComponent({
    super.key,
    required this.posts,
    required this.isLoading,
    required this.isDraft,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingComponent()
        : posts?.length == 0
        ? const ProfileNonPostComponent()
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: context.width * 0.02,
              mainAxisSpacing: context.width * 0.02,
              childAspectRatio: 0.75,
            ),
            itemCount: posts?.length,
            itemBuilder: (context, index) => ProfilePostGridItemComponent(
              post: posts![index],
              isDraft: isDraft,
            ),
          );
  }
}

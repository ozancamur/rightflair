import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/button/back_button.dart';
import 'package:rightflair/core/components/button/icon_button.dart';
import 'package:rightflair/core/components/post/post.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/post_detail/cubit/post_detail_cubit.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../comments/page/dialog_comments.dart';
import '../../create_post/model/post.dart';
import '../repository/post_detail_repository_impl.dart';

class PostDetailPage extends StatelessWidget {
  final PostModel post;
  final bool isDraft;
  const PostDetailPage({super.key, required this.post, required this.isDraft});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostDetailCubit(PostDetailRepositoryImpl())..init(post: post),
      child: BlocBuilder<PostDetailCubit, PostDetailState>(
        builder: (context, state) {
          return BaseScaffold(
            appBar: AppBarComponent(
              leading: BackButtonComponent(),
              actions: [
                IconButtonComponent(onTap: () {}, icon: AppIcons.EDIT),
                SizedBox(width: context.width * 0.03),
                IconButtonComponent(onTap: () {}, icon: AppIcons.DELETE),
                SizedBox(width: context.width * 0.04),
              ],
            ),
            body: BlocBuilder<PostDetailCubit, PostDetailState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: context.width * .05,
                    left: context.width * .05,
                    top: context.height * .025,
                    bottom: context.height * .075,
                  ),
                  child: PostComponent(
                    isDraft: isDraft,
                    post: state.post,
                    onComment: () => dialogComments(
                      context,
                      postId: post.id ?? "",
                      onAddComment: () =>
                          context.read<PostDetailCubit>().addComment(),
                    ),
                    onSave: () => context.read<PostDetailCubit>().onSavePost(),
                    onShare: () {},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

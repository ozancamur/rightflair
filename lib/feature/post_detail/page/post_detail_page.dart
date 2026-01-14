import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/back_button.dart';
import 'package:rightflair/core/components/icon_button.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/post_detail/cubit/post_detail_cubit.dart';

import '../../../core/base/base_scaffold.dart';
import '../../navigation/page/feed/widgets/feed_post_item.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailCubit, PostDetailState>(
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
                child: FeedPostItem(post: state.post),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/drag_handle.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../cubit/share_cubit.dart';
import '../widgets/share_animated_search.dart';
import '../widgets/share_horizontal_users_list.dart';
import '../widgets/share_report_post_button.dart';
import '../widgets/share_report_user_button.dart';
import '../widgets/share_send_button.dart';
import '../widgets/share_social_media_grid.dart';
import '../widgets/share_top_bar.dart';

class SharePage extends StatelessWidget {
  final String? postId;
  final String userId;
  const SharePage({super.key, this.postId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.secondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.width * 0.05),
            topRight: Radius.circular(context.width * 0.05),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DragHandleComponent(),
            const ShareTopBarWidget(),
            SizedBox(height: context.height * 0.005),
            BlocBuilder<ShareCubit, ShareState>(
              buildWhen: (prev, curr) => prev.isSearchOpen != curr.isSearchOpen,
              builder: (context, state) {
                if (state.isSearchOpen) {
                  return const ShareAnimatedSearchWidget();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ShareHorizontalUsersListWidget(),
                    ShareSendButtonWidget(userId: userId, postId: postId),
                  ],
                );
              },
            ),
            Divider(color: context.colors.onSurface),
            ShareSocialMediaGridWidget(postId: postId, userId: userId),
            Divider(color: context.colors.onSurface),
            postId == null || postId == ""
                ? ShareReportUserButtonWidget(userId: userId)
                : ShareReportPostButtonWidget(postId: postId!, userId: userId),
            SizedBox(height: context.height * 0.04),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';
import 'share_user_item.dart';

class ShareHorizontalUsersListWidget extends StatelessWidget {
  const ShareHorizontalUsersListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareCubit, ShareState>(
      buildWhen: (prev, curr) =>
          prev.users != curr.users ||
          prev.isLoading != curr.isLoading ||
          prev.selectedUser != curr.selectedUser,
      builder: (context, state) {
        if (state.isLoading && state.users.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.025),
            child: SizedBox(
              width: context.width * 0.05,
              height: context.width * 0.05,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.primary,
              ),
            ),
          );
        }

        if (state.users.isEmpty) {
          return SizedBox(height: context.height * 0.1);
        }

        return SizedBox(
          height: context.height * 0.1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              final isSelected = state.selectedUser?.id == user.id;
              return ShareUserItemWidget(user: user, isSelected: isSelected);
            },
          ),
        );
      },
    );
  }
}

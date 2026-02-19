import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/feature/share/model/share.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';
import 'share_user_avatar.dart';

class ShareUserWidget extends StatelessWidget {
  final SearchUserModel user;
  const ShareUserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareCubit, ShareState>(
      buildWhen: (previous, current) =>
          previous.selectedUser?.id != current.selectedUser?.id,
      builder: (context, state) {
        final isSelected = state.selectedUser?.id == user.id;

        return InkWell(
          onTap: () {
            context.read<ShareCubit>().toggleUserSelection(user);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.05,
              vertical: context.height * 0.008,
            ),
            child: Row(
              children: [
                ShareUserAvatarWidget(url: user.profilePhotoUrl),
                SizedBox(width: context.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextComponent(
                        text: user.username ?? '',
                        tr: false,
                        size: FontSizeConstants.NORMAL,
                        weight: FontWeight.w600,
                        color: context.colors.primary,
                      ),
                      if (user.fullName != null && user.fullName!.isNotEmpty)
                        TextComponent(
                          text: user.fullName!,
                          tr: false,
                          size: FontSizeConstants.SMALL,
                          weight: FontWeight.w400,
                          color: context.colors.primaryContainer,
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: context.width * 0.065,
                    height: context.width * 0.065,
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: context.colors.secondary,
                      size: context.width * 0.04,
                    ),
                  )
                else
                  Container(
                    width: context.width * 0.065,
                    height: context.width * 0.065,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.primaryContainer,
                        width: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

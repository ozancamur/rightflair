import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../feature/main/navigation/cubit/navigation_cubit.dart';
import '../../constants/color/color.dart';
import '../../constants/font/font_size.dart';
import '../../constants/icons.dart';
import '../../constants/string.dart';
import '../../extensions/context.dart';
import 'post_action_icon.dart';

class PostActionsComponent extends StatelessWidget {
  final String postId;
  final int comment;
  final int saved;
  final int shared;
  final VoidCallback onComment;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final bool isSaved;
  const PostActionsComponent({
    super.key,
    required this.postId,
    required this.comment,
    required this.saved,
    required this.shared,
    required this.onComment,
    required this.onSave,
    required this.onShare,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: context.width * .04,
      bottom: context.width * .08,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: context.height * .01,
        children: [
          PostIconButtonWidget(
            onTap: onComment,
            icon: AppIcons.MESSAGE_FILLED,
            value: comment,
          ),
          PostIconButtonWidget(
            onTap: () {
              onSave();
              if (!isSaved) _showSavedSnackBar(context);
            },
            icon: AppIcons.SAVE_FILLED,
            value: saved,
            isActive: isSaved,
          ),
          PostIconButtonWidget(
            onTap: onShare,
            icon: AppIcons.SHARE_FILLED,
            value: shared,
          ),
        ],
      ),
    );
  }

  void _showSavedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  AppStrings.POST_SAVED.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontSizeConstants.NORMAL.first,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                context.read<NavigationCubit>().route(3);
                // Pop back to NavigationPage if on a pushed route
                while (context.canPop()) {
                  context.pop();
                }
              },
              child: Text(
                AppStrings.POST_SAVED_VIEW.tr(),
                style: TextStyle(
                  color: AppColors.ORANGE,
                  fontSize: FontSizeConstants.NORMAL.first,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: context.colors.onSecondaryFixed.withOpacity(.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(
          vertical: context.height * .02,
          horizontal: context.width * .04,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: context.width * .04,
          vertical: context.height * .02,
        ),
      ),
    );
  }
}
